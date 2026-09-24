#!/usr/bin/env bash

set -euo pipefail

readonly EXIT_GIT=10
readonly EXIT_HEAD=11
readonly EXIT_DIRTY=20
readonly EXIT_BASE=21
readonly EXIT_MERGE_BASE=22
readonly EXIT_DIFF=23
readonly EXIT_PYTHON=24
readonly EXIT_USAGE=64

base_override=''
base_was_supplied=0
work_dir=''

usage() {
  cat <<'EOF'
Usage: review-orchestrator.sh [--base REF]

Extract a clean current branch's committed PR-style diff into an external
hunk bundle. The default base is origin/HEAD, then an unambiguous origin/main
or origin/master, then an unambiguous local main or master.

Options:
  --base REF  Compare against this branch or commit instead of auto-detecting.
  -h, --help  Show this help.

Working-tree changes are never included. A dirty working tree stops the run.
EOF
}

fail() {
  local exit_code="$1"
  shift
  printf 'REVIEW_ORCHESTRATOR_ERROR[%s]: %s\n' "$exit_code" "$*" >&2
  exit "$exit_code"
}

report_retained_bundle() {
  local exit_code=$?
  if (( exit_code != 0 )) && [[ -n "$work_dir" && -d "$work_dir" ]]; then
    printf 'REVIEW_ORCHESTRATOR_BUNDLE_RETAINED: %s\n' "$work_dir" >&2
  fi
}
trap report_retained_bundle EXIT

while (($#)); do
  case "$1" in
    --base)
      if (( base_was_supplied )) || (($# < 2)) || [[ -z "$2" || "$2" == --* ]]; then
        fail "$EXIT_USAGE" '--base requires exactly one ref'
      fi
      base_override="$2"
      base_was_supplied=1
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "$EXIT_USAGE" "unknown argument: $1"
      ;;
  esac
done

command -v git >/dev/null 2>&1 || fail "$EXIT_GIT" 'Git is not available'
repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || fail "$EXIT_GIT" 'current directory is not inside a Git working tree'
cd "$repo_root" || fail "$EXIT_GIT" "cannot enter repository root: $repo_root"

if ! dirty_status="$(git status --porcelain=v1 --untracked-files=all --ignore-submodules=none 2>&1)"; then
  fail "$EXIT_GIT" "cannot inspect Git status: $dirty_status"
fi
if [[ -n "$dirty_status" ]]; then
  printf 'REVIEW_ORCHESTRATOR_BLOCKED_DIRTY\n' >&2
  printf 'The working tree must be clean. Git status entries:\n%s\n' "$dirty_status" >&2
  exit "$EXIT_DIRTY"
fi

head_commit="$(git rev-parse --verify --quiet 'HEAD^{commit}' 2>/dev/null)" || fail "$EXIT_HEAD" 'HEAD does not resolve to a commit'
branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
if [[ -z "$branch" ]]; then
  branch="detached-$(git rev-parse --short=12 HEAD)"
fi

resolve_commit() {
  git rev-parse --verify --quiet "${1}^{commit}" 2>/dev/null
}

if (( base_was_supplied )); then
  base_ref="$base_override"
  base_commit="$(resolve_commit "$base_ref")" || fail "$EXIT_BASE" "Base ref does not resolve to a commit: $base_ref"
else
  base_ref=''
  base_commit=''
  origin_head="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [[ -n "$origin_head" ]]; then
    if candidate_commit="$(resolve_commit "$origin_head")"; then
      base_ref="$origin_head"
      base_commit="$candidate_commit"
    fi
  fi

  if [[ -z "$base_commit" ]]; then
    declare -a remote_candidates=()
    for candidate in origin/main origin/master; do
      if candidate_commit="$(resolve_commit "$candidate")"; then
        remote_candidates+=("$candidate")
      fi
    done
    if ((${#remote_candidates[@]} == 1)); then
      base_ref="${remote_candidates[0]}"
      base_commit="$(resolve_commit "$base_ref")"
    elif ((${#remote_candidates[@]} > 1)); then
      fail "$EXIT_BASE" 'both origin/main and origin/master resolve, but origin/HEAD is unavailable; supply --base REF'
    fi
  fi

  if [[ -z "$base_commit" ]]; then
    declare -a local_candidates=()
    for candidate in main master; do
      if candidate_commit="$(resolve_commit "$candidate")"; then
        local_candidates+=("$candidate")
      fi
    done
    if ((${#local_candidates[@]} == 1)); then
      base_ref="${local_candidates[0]}"
      base_commit="$(resolve_commit "$base_ref")"
    elif ((${#local_candidates[@]} > 1)); then
      fail "$EXIT_BASE" 'both local main and master resolve, but no remote default base was found; supply --base REF'
    fi
  fi

  [[ -n "$base_commit" ]] || fail "$EXIT_BASE" 'no unambiguous Base was found; supply --base REF'
fi

merge_base="$(git merge-base "$base_commit" "$head_commit" 2>/dev/null)" || fail "$EXIT_MERGE_BASE" "no merge base exists for Base $base_ref and HEAD"

command -v python3 >/dev/null 2>&1 || fail "$EXIT_PYTHON" 'Python 3 is required to create the hunk manifest'

tmp_parent="${TMPDIR:-/tmp}"
if [[ "$tmp_parent" != /* ]]; then
  tmp_parent="$repo_root/$tmp_parent"
fi
work_dir="$(mktemp -d "$tmp_parent/review-orchestrator.XXXXXXXX")" || fail "$EXIT_DIFF" "cannot create a temporary bundle under $tmp_parent"
chmod 700 "$work_dir" || fail "$EXIT_DIFF" "cannot secure temporary bundle: $work_dir"

if ! git diff \
  --no-ext-diff \
  --no-textconv \
  --no-color \
  --find-renames \
  --ignore-submodules=none \
  --unified=3 \
  "$merge_base" "$head_commit" -- > "$work_dir/diff.patch"; then
  fail "$EXIT_DIFF" 'git diff failed'
fi

if [[ ! -s "$work_dir/diff.patch" ]]; then
  rm -rf -- "$work_dir"
  work_dir=''
  printf 'STATUS: no_changes\n'
  printf 'BASE_REF: %s\n' "$base_ref"
  printf 'BASE_COMMIT: %s\n' "$base_commit"
  printf 'MERGE_BASE: %s\n' "$merge_base"
  printf 'HEAD_COMMIT: %s\n' "$head_commit"
  printf 'BRANCH: %s\n' "$branch"
  exit 0
fi

if ! git diff --name-status -z --find-renames --ignore-submodules=none "$merge_base" "$head_commit" -- > "$work_dir/name-status.z"; then
  fail "$EXIT_DIFF" 'git diff could not enumerate changed paths'
fi
if ! git diff --raw --no-abbrev -z --find-renames --ignore-submodules=none "$merge_base" "$head_commit" -- > "$work_dir/raw-status.z"; then
  fail "$EXIT_DIFF" 'git diff could not enumerate file modes and change types'
fi

if ! summary="$(python3 - "$work_dir" "$base_ref" "$base_commit" "$merge_base" "$head_commit" "$branch" <<'PY'
import json
import os
import re
import sys
from pathlib import PurePosixPath

bundle_dir, base_ref, base_commit, merge_base, head_commit, branch = sys.argv[1:]


def decode_path(value):
    return os.fsdecode(value)


def parse_name_status(data):
    tokens = data.split(b"\0")
    records = []
    index = 0
    while index < len(tokens) - 1:
        status = tokens[index].decode("ascii", "replace")
        index += 1
        if status.startswith(("R", "C")):
            if index + 1 >= len(tokens):
                raise ValueError("truncated rename/copy record in name-status output")
            old_path = decode_path(tokens[index])
            path = decode_path(tokens[index + 1])
            index += 2
        else:
            if index >= len(tokens):
                raise ValueError("truncated path in name-status output")
            path = decode_path(tokens[index])
            index += 1
            old_path = path if status == "D" else None
        records.append({"status": status, "path": path, "old_path": old_path})
    return records


def parse_raw_status(data):
    tokens = data.split(b"\0")
    records = []
    index = 0
    while index < len(tokens) - 1:
        header = tokens[index].decode("ascii", "replace")
        index += 1
        fields = header.split()
        if len(fields) < 5 or not fields[0].startswith(":"):
            raise ValueError("invalid raw status record")
        old_mode = fields[0][1:]
        new_mode = fields[1]
        status = fields[4]
        if status.startswith(("R", "C")):
            if index + 1 >= len(tokens):
                raise ValueError("truncated rename/copy record in raw status output")
            old_path = decode_path(tokens[index])
            path = decode_path(tokens[index + 1])
            index += 2
        else:
            if index >= len(tokens):
                raise ValueError("truncated path in raw status output")
            path = decode_path(tokens[index])
            index += 1
            old_path = path if status == "D" else None
        records.append({
            "old_mode": old_mode,
            "new_mode": new_mode,
            "status": status,
            "path": path,
            "old_path": old_path,
        })
    return records


def classify(path):
    basename = PurePosixPath(path).name.lower()
    if basename == "dockerfile" or basename.startswith("dockerfile."):
        return "Dockerfile", "configuration"
    special = {
        "makefile": ("Makefile", "build-configuration"),
        "justfile": ("Justfile", "build-configuration"),
        "cmakelists.txt": ("CMake", "build-configuration"),
        ".gitignore": ("Git ignore", "configuration"),
        ".gitattributes": ("Git attributes", "configuration"),
        ".editorconfig": ("EditorConfig", "configuration"),
    }
    if basename in special:
        return special[basename]
    suffix = PurePosixPath(basename).suffix.lower()
    if basename.endswith(".d.ts"):
        return "TypeScript", "source"
    mapping = {
        ".py": ("Python", "source"), ".pyi": ("Python", "source"),
        ".js": ("JavaScript", "source"), ".jsx": ("JavaScript", "source"),
        ".mjs": ("JavaScript", "source"), ".cjs": ("JavaScript", "source"),
        ".ts": ("TypeScript", "source"), ".tsx": ("TypeScript", "source"),
        ".java": ("Java", "source"), ".kt": ("Kotlin", "source"),
        ".kts": ("Kotlin", "source"), ".go": ("Go", "source"),
        ".rs": ("Rust", "source"), ".rb": ("Ruby", "source"),
        ".php": ("PHP", "source"), ".cs": ("C#", "source"),
        ".fs": ("F#", "source"), ".fsx": ("F#", "source"),
        ".c": ("C", "source"), ".cc": ("C++", "source"),
        ".cpp": ("C++", "source"), ".cxx": ("C++", "source"),
        ".h": ("C/C++ header", "source"), ".hh": ("C++", "source"),
        ".hpp": ("C++", "source"), ".hxx": ("C++", "source"),
        ".m": ("Objective-C or MATLAB", "unknown"),
        ".mm": ("Objective-C++", "source"),
        ".swift": ("Swift", "source"), ".scala": ("Scala", "source"),
        ".sc": ("Scala", "source"), ".ex": ("Elixir", "source"),
        ".exs": ("Elixir", "source"), ".erl": ("Erlang", "source"),
        ".hrl": ("Erlang", "source"), ".clj": ("Clojure", "source"),
        ".cljs": ("ClojureScript", "source"), ".cljc": ("Clojure", "source"),
        ".hs": ("Haskell", "source"), ".lhs": ("Haskell", "source"),
        ".lua": ("Lua", "source"), ".pl": ("Perl", "source"),
        ".pm": ("Perl", "source"), ".r": ("R", "source"),
        ".R": ("R", "source"), ".sql": ("SQL", "source"),
        ".sh": ("Shell", "source"), ".bash": ("Shell", "source"),
        ".zsh": ("Shell", "source"), ".fish": ("Fish", "source"),
        ".ps1": ("PowerShell", "source"), ".bat": ("Batch", "source"),
        ".cmd": ("Batch", "source"), ".html": ("HTML", "markup"),
        ".htm": ("HTML", "markup"), ".css": ("CSS", "stylesheet"),
        ".scss": ("SCSS", "stylesheet"), ".sass": ("Sass", "stylesheet"),
        ".less": ("Less", "stylesheet"), ".vue": ("Vue", "source"),
        ".svelte": ("Svelte", "source"), ".astro": ("Astro", "source"),
        ".json": ("JSON", "configuration"), ".jsonc": ("JSONC", "configuration"),
        ".yaml": ("YAML", "configuration"), ".yml": ("YAML", "configuration"),
        ".toml": ("TOML", "configuration"), ".ini": ("INI", "configuration"),
        ".cfg": ("INI", "configuration"), ".conf": ("Configuration", "configuration"),
        ".xml": ("XML", "configuration"), ".properties": ("Properties", "configuration"),
        ".gradle": ("Gradle", "build-configuration"), ".tf": ("Terraform", "configuration"),
        ".hcl": ("HCL", "configuration"), ".proto": ("Protocol Buffers", "source"),
        ".graphql": ("GraphQL", "source"), ".gql": ("GraphQL", "source"),
        ".md": ("Markdown", "documentation"), ".mdx": ("MDX", "documentation"),
        ".rst": ("reStructuredText", "documentation"), ".adoc": ("AsciiDoc", "documentation"),
        ".txt": ("Plain text", "documentation"), ".feature": ("Gherkin", "documentation"),
    }
    return mapping.get(suffix, ("unknown", "unknown"))


def split_sections(data):
    sections = []
    current = []
    for line in data.splitlines(keepends=True):
        if line.startswith((b"diff --git ", b"diff --cc ", b"diff --combined ")):
            if current:
                sections.append(current)
            current = [line]
        elif current:
            current.append(line)
    if current:
        sections.append(current)
    return sections


hunk_header = re.compile(
    br"^@@+\s+-(\d+)(?:,(\d+))?\s+\+(\d+)(?:,(\d+))?\s+@@+"
)


def extract_hunks(section):
    prefix = []
    chunks = []
    current = None
    for line in section:
        if hunk_header.match(line):
            if current is not None:
                chunks.append(current)
            current = [line]
        elif current is None:
            prefix.append(line)
        else:
            current.append(line)
    if current is not None:
        chunks.append(current)
    return prefix, chunks


try:
    with open(os.path.join(bundle_dir, "name-status.z"), "rb") as stream:
        files = parse_name_status(stream.read())
    with open(os.path.join(bundle_dir, "raw-status.z"), "rb") as stream:
        raw_files = parse_raw_status(stream.read())
    with open(os.path.join(bundle_dir, "diff.patch"), "rb") as stream:
        diff_data = stream.read()
    sections = split_sections(diff_data)

    if len(files) != len(raw_files) or len(files) != len(sections):
        raise ValueError(
            "changed-path, raw-status, and patch inventories do not match "
            f"({len(files)}, {len(raw_files)}, {len(sections)})"
        )

    os.makedirs(os.path.join(bundle_dir, "hunks"), exist_ok=True)
    all_hunks = []
    for index, file_record in enumerate(files):
        raw = raw_files[index]
        section = sections[index]
        path = file_record["path"]
        language, category = classify(path)
        prefix, chunks = extract_hunks(section)
        binary = any(b"Binary files " in line or b"GIT binary patch" in line for line in section)
        submodule = raw["old_mode"] == "160000" or raw["new_mode"] == "160000"
        file_hunks = []
        additions_total = 0
        deletions_total = 0

        for hunk_index, chunk in enumerate(chunks, start=1):
            match = hunk_header.match(chunk[0])
            if not match:
                raise ValueError("unable to parse a unified hunk header")
            old_start, old_count, new_start, new_count = match.groups()
            additions = sum(1 for line in chunk[1:] if line.startswith(b"+"))
            deletions = sum(1 for line in chunk[1:] if line.startswith(b"-"))
            hunk_id = f"H{len(all_hunks) + 1:06d}"
            patch_rel = f"hunks/{hunk_id}.patch"
            patch_path = os.path.join(bundle_dir, patch_rel)
            with open(patch_path, "wb") as patch_file:
                patch_file.write(b"".join(prefix + chunk))
            hunk_record = {
                "id": hunk_id,
                "file_id": f"F{index + 1:06d}",
                "path": path,
                "old_path": file_record["old_path"],
                "language": language,
                "category": category,
                "patch": patch_rel,
                "old_start": int(old_start),
                "old_lines": int(old_count or b"1"),
                "new_start": int(new_start),
                "new_lines": int(new_count or b"1"),
                "additions": additions,
                "deletions": deletions,
                "changed_lines": additions + deletions,
            }
            all_hunks.append(hunk_record)
            file_hunks.append(hunk_record)
            additions_total += additions
            deletions_total += deletions

        is_metadata_only = not chunks and not binary and not submodule
        metadata_patch = None
        if is_metadata_only:
            metadata_patch = f"files/F{index + 1:06d}.patch"
            metadata_path = os.path.join(bundle_dir, metadata_patch)
            os.makedirs(os.path.dirname(metadata_path), exist_ok=True)
            with open(metadata_path, "wb") as patch_file:
                patch_file.write(b"".join(section))

        file_record.update({
            "id": f"F{index + 1:06d}",
            "language": language,
            "category": category,
            "additions": additions_total,
            "deletions": deletions_total,
            "changed_lines": additions_total + deletions_total,
            "hunks": file_hunks,
            "binary": binary,
            "submodule": submodule,
            "metadata_only": is_metadata_only,
            "metadata_patch": metadata_patch,
            "reviewable": not binary and not submodule,
        })

    manifest = {
        "schema_version": 1,
        "comparison": {
            "base_ref": base_ref,
            "base_commit": base_commit,
            "merge_base": merge_base,
            "head_ref": "HEAD",
            "head_commit": head_commit,
            "branch": branch,
            "working_tree": "clean",
            "diff_kind": "merge-base-to-HEAD (PR-style three-dot comparison)",
        },
        "file_count": len(files),
        "hunk_count": len(all_hunks),
        "files": files,
        "hunks": all_hunks,
    }
    with open(os.path.join(bundle_dir, "manifest.json"), "w", encoding="utf-8") as stream:
        json.dump(manifest, stream, ensure_ascii=True, indent=2)
        stream.write("\n")
except Exception as error:
    print(f"manifest generation failed: {error}", file=sys.stderr)
    sys.exit(1)

print(f"FILES: {len(files)}")
print(f"HUNKS: {len(all_hunks)}")
PY
)"; then
  fail "$EXIT_PYTHON" 'could not create the structured hunk bundle'
fi

printf 'STATUS: ready\n'
printf 'BASE_REF: %s\n' "$base_ref"
printf 'BASE_COMMIT: %s\n' "$base_commit"
printf 'MERGE_BASE: %s\n' "$merge_base"
printf 'HEAD_COMMIT: %s\n' "$head_commit"
printf 'BRANCH: %s\n' "$branch"
printf 'BUNDLE_DIR: %s\n' "$work_dir"
printf '%s\n' "$summary"

---
name: web-prototype
description: Defines a disposable, single-HTML-file web mock with self-contained JavaScript and local browser viewing. Use only when the user explicitly asks for a web prototype.
---

# Web Prototype

## Purpose and Scope

This skill defines what a web prototype is, the boundaries of its use, and a minimal way to make one available for local browser viewing. It does not prescribe how to design, author, or verify a prototype, and it does not require a prototype output or authorize creating one.

The user's request and applicable project instructions govern whether to create or retain an artefact. The agent MUST use this skill only when the user explicitly asks for a web prototype. The agent MUST NOT infer that a web-related task calls for a prototype or suggest one solely because a change affects a web interface.

## Normative Terms

- **MUST** and **MUST NOT** state mandatory rules and prohibitions.
- **MAY** permits an action but does not require it.
- **SHOULD** indicates a recommended action that may be omitted when there is a good reason.

## Definition

A **web prototype** is a disposable mock used to demonstrate an idea or change in a web interface. Its prototype source is one HTML file containing the markup, styles, and self-contained JavaScript.

The HTML file MAY reference existing local project assets, including images. A prototype does not add separate asset files.

A prototype MAY simulate key interactions using its JavaScript. These interactions run locally in the mock; they do not connect to a real backend or establish that the product behaviour has been implemented.

## Local Viewing

When the prototype is to be viewed in a browser, the agent SHOULD serve it from the project root using Python's standard-library static server. Run this from the project root:

```bash
python3 -u -m http.server 0 --bind 127.0.0.1
```

Port `0` asks the operating system to assign an available ephemeral port. The server prints the actual port and URL; share that URL, appending the prototype's project-relative path when it is not at the root. Keep the server process running while it is being viewed, then stop it when viewing is finished. This serves static files only; it does not run an application's build or backend server.

The server exposes files under the project root to clients able to connect to the local machine. Confirm that this is an appropriate directory to serve, and keep the bind address at `127.0.0.1` rather than exposing it to the network.

## Lifecycle and Limits

“Disposable” describes the prototype's role, not a requirement to delete it. A prototype MAY be retained or committed as a review artefact. It MUST NOT be treated as production code or as a substitute for implementing the change in the product.

This skill defines the concept and its limits and provides a minimal local static-server setup for viewing. It does not prescribe how to create or verify a prototype.

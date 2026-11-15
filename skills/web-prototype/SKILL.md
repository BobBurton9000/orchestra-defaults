---
name: web-prototype
description: Defines a disposable, single-HTML-file web mock with self-contained JavaScript for demonstrating an idea or change. Use only when the user explicitly asks for a web prototype.
---

# Web Prototype

## Purpose and Scope

This skill defines what a web prototype is and the boundaries of its use. It is a reference, not a workflow for designing, authoring, running, or testing a prototype. It does not require a prototype output or authorize creating one.

The user's request and applicable project instructions govern whether to create or retain an artefact. The agent MUST use this skill only when the user explicitly asks for a web prototype. The agent MUST NOT infer that a web-related task calls for a prototype or suggest one solely because a change affects a web interface.

## Normative Terms

- **MUST** and **MUST NOT** state mandatory rules and prohibitions.
- **MAY** permits an action but does not require it.

## Definition

A **web prototype** is a disposable mock used to demonstrate an idea or change in a web interface. Its prototype source is one HTML file containing the markup, styles, and self-contained JavaScript.

The HTML file MAY reference existing local project assets, including images. A prototype does not add separate asset files.

A prototype MAY simulate key interactions using its JavaScript. These interactions run locally in the mock; they do not connect to a real backend or establish that the product behaviour has been implemented.

## Lifecycle and Limits

“Disposable” describes the prototype's role, not a requirement to delete it. A prototype MAY be retained or committed as a review artefact. It MUST NOT be treated as production code or as a substitute for implementing the change in the product.

This skill defines the concept and its limits only. It does not prescribe how to create, launch, inspect, or verify a prototype.

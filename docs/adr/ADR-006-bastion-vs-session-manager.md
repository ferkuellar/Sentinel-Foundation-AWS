# ADR-006: Bastion Access Pattern vs Session Manager Pattern

## Status

Accepted

## Context

The project requires a secure administrative access pattern for the network foundation. A decision is needed between a visible bastion-based approach and a more mature operational pattern based on AWS Systems Manager Session Manager.

## Decision

This project uses a bastion-oriented access pattern for the current baseline, while documenting Session Manager as the preferred future-state direction.

## Rationale

This option was selected because it provides:

- easy architectural visibility
- simple explanation in diagrams
- clear demonstration value for portfolio work
- lower conceptual barrier during the baseline phase

## Consequences

### Positive

- straightforward to explain
- easy to represent in diagrams
- useful for interview storytelling

### Negative

- larger exposure surface
- dependence on trusted admin IP maintenance
- weaker posture than a mature Session Manager design

## Follow-up

Future evolution should evaluate:

- Session Manager
- reduced inbound exposure
- stronger operational security posture

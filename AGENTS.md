# AGENTS.md

## Definition Of Done

- Bug fixes and features must ship via PR.
- PRs must include validation for changed behavior (tests or reproducible validation notes for docs-first changes).
- PRs must include deployment/publication evidence when applicable, or explicit `N/A` with reason.

## Start-Task Preflight

Use the global preflight command before major work:

```bash
cstart <task-slug>
```

## Fast Check Gate

```bash
./scripts/fast-check.sh
```

Default checks verify required docs structure and reference files for the skill.

## PR Automation

```bash
./scripts/open-pr.sh
```

## Post-Merge Recap

`post-merge-recap` runs on pushes to `main`/`master` and uploads a markdown recap artifact.

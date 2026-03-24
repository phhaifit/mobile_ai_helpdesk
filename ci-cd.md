## Overview
Set up a CI/CD pipeline to automate building, testing, and distributing the Flutter app, using Github Actions.

## Tasks

- Configure automated build on push to main/develop branches

- Run Flutter analyzer and unit tests on every PR

- Automate test flight / internal track distribution for dev builds

- Set up production release workflow (manual trigger)

- Store secrets securely (signing keys, API keys) in CI environment

- Add build status badge to repository README

## Acceptance Criteria

- PRs automatically trigger lint + test pipeline

- Successful merges to develop auto-distribute a build to testers

- Production release pipeline deployable with a single trigger

- No secrets hardcoded in the repository

- Pipeline status visible per commit/PR
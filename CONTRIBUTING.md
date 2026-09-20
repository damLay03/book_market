# Contributing

## Branches and commits

- Branch from `develop` using `feature/<ticket>-short-name`,
  `fix/<ticket>-short-name`, or `chore/<short-name>`.
- Use Conventional Commits, for example `feat(catalog): add book filters`.
- Keep pull requests small, reviewable, and focused on one outcome.

## Local setup

1. Install FVM and run `fvm install`.
2. Run `fvm flutter pub get`.
3. Copy `dart_defines.example.json` to `dart_defines.json` and set local values.
4. Run the development flavor as documented in the README.

Do not commit `dart_defines.json`, signing keys, service-account files, or
credentials. A client application cannot safely contain a true secret.

## Definition of done

- Acceptance criteria are met on supported screen sizes.
- Accessibility labels and keyboard/screen-reader behavior are considered.
- Loading, empty, error, offline, and retry behavior are implemented.
- New behavior is tested and all quality commands pass.
- Screenshots or a short recording are attached for visible UI changes.
- Documentation and localization files are updated.

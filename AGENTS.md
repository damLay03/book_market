# Book Market coding contract

This file is the source of truth for humans and coding agents working in this
repository. Read it before changing code.

## Non-negotiable checks

Before handing work off, run:

```sh
dart format .
dart run build_runner build
flutter analyze --fatal-infos
flutter test --test-randomize-ordering-seed random
```

For platform/configuration changes, also build the affected flavor.

## Architecture

- Organize product code by feature under `lib/features/<feature>`.
- A feature may contain `data`, `domain`, and `presentation`; do not create an
  empty layer merely to satisfy the folder structure.
- Shared product-independent code belongs in `lib/core`.
- Features must not import another feature's `data` or `presentation` layer.
- UI talks to Cubits/Blocs. Cubits/Blocs depend on repository interfaces, not
  Dio, secure storage, or JSON maps.
- Register app-wide dependencies in `core/di/injection.dart`. Keep
  screen-scoped dependencies close to their route/widget.
- Add navigation paths and names centrally in `core/routing`.

## Code rules

- Use package imports, immutable state, typed failures, and explicit names.
- Never log tokens, passwords, payment data, or full response bodies in
  production.
- Never hardcode secrets or environment-specific URLs.
- Put all user-facing text in ARB localization files.
- Every asynchronous screen handles loading, empty, success, and error states.
- Prefer small widgets and composition; avoid files above roughly 300 lines.
- Generated `*.g.dart` and `*.freezed.dart` files must be committed.

## Testing rules

- Domain logic and Cubits/Blocs require unit tests.
- Repositories require success, server-error, network-error, and malformed-data
  tests.
- Critical screens require widget tests using deterministic fakes.
- A bug fix includes a regression test whenever practical.
- Repository-wide line coverage must remain at or above 80%.

## Scope discipline

- Do not refactor unrelated code in a feature PR.
- Do not add a dependency if the SDK or an existing package already solves the
  problem clearly.
- Update documentation when changing architecture, commands, or configuration.

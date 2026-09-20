# Book Market

Production-oriented Flutter frontend starter for the Book Market team.

## Stack

- Flutter 3.47.5 / Dart 3.13
- Bloc/Cubit for state management
- GoRouter for navigation
- Dio for HTTP and interceptors
- GetIt as the application composition root
- Secure storage and shared preferences
- Freezed and json_serializable code generation
- ARB localization, Material 3, strict analysis, tests, and CI

Architecture details live in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
Shared UI rules live in [docs/DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md).
All contributors and coding agents must follow [AGENTS.md](AGENTS.md).

## First-time setup

```sh
fvm install
fvm flutter pub get
fvm dart run build_runner build
```

If FVM is unavailable, install Flutter 3.47.5 and omit the `fvm` prefix.

Create the ignored files used by the VS Code launch profiles:

```sh
cp dart_defines.example.json dart_defines.development.json
cp dart_defines.staging.example.json dart_defines.staging.json
cp dart_defines.production.example.json dart_defines.production.json
```

Replace the sample URLs for real environments. Development intentionally uses
deterministic fake Catalog data; staging and production samples do not.
Production rejects fake data and requires HTTPS. Never put a secret in a
Flutter client or commit a local define file.

## Run

```sh
# Development
fvm flutter run --flavor development \
  --target lib/main_development.dart \
  --dart-define-from-file=dart_defines.development.json

# Staging
fvm flutter run --flavor staging \
  --target lib/main_staging.dart \
  --dart-define-from-file=dart_defines.staging.json

# Production
fvm flutter run --flavor production \
  --target lib/main_production.dart \
  --dart-define-from-file=dart_defines.production.json

# Web (development; web does not use the native flavor flag)
fvm flutter run -d chrome \
  --target lib/main_development.dart \
  --dart-define-from-file=dart_defines.development.json
```

VS Code launch profiles are included for native targets and development on
Chrome. Without a define file, development uses `http://10.0.2.2:8080/api/v1`
and the deterministic fake Catalog repository. Staging and production fail
fast unless `API_BASE_URL` is supplied; production also requires HTTPS and
rejects `USE_FAKE_DATA=true`.

## Quality gate

```sh
fvm dart format .
fvm dart run build_runner build
fvm flutter analyze --fatal-infos
fvm dart run bloc_tools:bloc lint .
fvm flutter test --coverage --test-randomize-ordering-seed random
```

The same checks run on pull requests. CI also performs an Android development
APK and web smoke builds and rejects line coverage below 80%.

## Adding product code

Read [docs/ADDING_A_FEATURE.md](docs/ADDING_A_FEATURE.md). Product features live
under `lib/features`; shared infrastructure lives under `lib/core`. Catalog is
the end-to-end golden feature demonstrating DTO generation, API data sources,
repository boundaries, typed failures, Cubit states, search, retry, refresh,
localization, accessibility, fake data, and tests. Counter remains only as a
minimal Bloc/widget example at `/reference-counter`.

## Flavors and identifiers

| Flavor | Android/iOS suffix | Display name |
|---|---|---|
| development | `.dev` | `[DEV] Book Market` |
| staging | `.stg` | `[STG] Book Market` |
| production | none | `Book Market` |

The base bundle/application ID is `com.fpt.bookmarket`. Change it before any
store, Firebase, deep-link, or push-notification registration if the team owns
a different reverse-domain identifier.

## Collaboration

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming, Conventional Commits,
pull-request expectations, secrets policy, and the definition of done.

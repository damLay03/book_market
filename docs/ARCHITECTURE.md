# Architecture

Book Market uses feature-first clean boundaries without forcing ceremony on
simple screens.

```text
lib/
├── app/                 # Root MaterialApp
├── core/                # Config, DI, networking, routing, storage, theme
├── features/
│   └── <feature>/
│       ├── data/        # DTOs, data sources, repository implementations
│       ├── domain/      # Entities, repository contracts, use cases
│       └── presentation/# Cubits/Blocs, states, pages, widgets
├── l10n/                # ARB source and generated localization code
└── main_<flavor>.dart
```

Dependencies point inward: presentation uses domain; data implements domain;
domain knows neither Flutter nor Dio. Simple, UI-only features may start with
`presentation` and add other layers when they gain business or I/O logic.

## Data flow

```text
Widget → Cubit/Bloc → Repository interface → Repository implementation
       ← UI state   ← Entity/failure       ← API/cache/storage
```

`AppException` represents infrastructure failures. Repositories should map
these to feature-specific failures before presentation consumes them.

## Environments

The native flavors select the app identity. Dart entrypoints select
`AppFlavor`. Runtime-safe configuration enters through compile-time
`--dart-define` values. Secrets must remain on the server.

## Decisions

- Bloc/Cubit: explicit, testable state transitions.
- GetIt: composition root only; avoid service-locator calls inside widgets.
- GoRouter: centralized typed navigation boundary.
- Dio: interceptors, cancellation, timeouts, and consistent error mapping.
- Freezed/json_serializable: immutable state and typed JSON models.

## Golden path

`features/catalog` is executable architecture documentation. Development uses
its fake repository by default, while staging and production resolve the remote
implementation. Keep this switch at the DI boundary; product widgets must not
know which data source is active.

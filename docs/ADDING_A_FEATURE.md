# Adding a feature

1. Create `lib/features/<name>/presentation` and add domain/data folders only
   when needed.
2. Define the domain entity and repository contract before the API DTO.
3. Implement DTO conversion and repository error mapping in `data`.
4. Register app-wide dependencies in the composition root.
5. Model all UI states explicitly with Freezed or a sealed class.
6. Add the route, localized strings, and loading/empty/error/success UI.
7. Add unit and widget tests before opening the pull request.

Never expose Dio responses, JSON maps, or storage packages above the data layer.

Use `features/catalog` as the canonical working example. New asynchronous
features must provide the same loading, empty, error, retry, fake-data, and test
coverage behavior unless the product requirement makes a state impossible.

# Design system

Use the shared tokens and component themes before introducing local values.
This keeps screens visually consistent across contributors and generated code.

## Layout

- Spacing uses the 4, 8, 12, 16, 24, 32, and 48 logical-pixel scale from
  `AppSpacing`.
- Content is compact below 600 px, adaptive from 600 px, and expanded from
  1024 px. Long-form page content is capped at 1200 px with `AppBreakpoints`.
- Compact screens use one content column. Wider screens may use grids while
  preserving a minimum useful card width.
- Pages use 16 px horizontal padding on compact screens and 24 px otherwise.

## Typography and components

`AppTheme` owns the type scale, 48 px minimum button height, 12 px control
radius, input styling, and 16 px card radius. Prefer `titleLarge`,
`titleMedium`, `bodyLarge`, `bodyMedium`, and `labelLarge` instead of custom
font sizes.

Feature widgets own product-specific patterns. Catalog's `BookCard` is the
reference for book summaries: title, author, price, and a stable leading
visual. Extend that widget instead of creating another book-card style.

All visible copy must come from ARB files. Check light and dark themes, text
scaling, keyboard focus, and both compact and wide layouts for visible UI
changes.

# Copilot Instructions for tmdb-web-translations

## Overview

This is a Ruby gem that provides internationalization (i18n) data and utilities for TMDB (The Movie Database). It manages locale-specific translations, country/language metadata, pluralization rules, and transliteration rules.

## Build, Test, and Lint

### Install Dependencies
```bash
bundle install
```

### Run All Tests
```bash
bundle exec rspec
```

### Run a Single Test File
```bash
bundle exec rspec spec/i18n_patch_spec.rb
```

### Run a Single Test (by description)
```bash
bundle exec rspec -e "merging values"
```

### Run Linter
```bash
bundle exec rubocop
```

### Auto-fix Linter Issues
```bash
bundle exec rubocop -a
```

### Interactive Console
```bash
bundle exec bin/console
```

## Architecture

### Directory Structure

- **`lib/tmdb/web/translations/`**: Core library code
  - `i18n.rb`: Main i18n setup; loads all locale data into I18n backend
  - `i18n_fallbacks.rb`: Sets up I18n fallback chain for locale resolution
  
- **`lib/tmdb/`**: Utility classes
  - `i18n_patch.rb`: Generates patches for merging new translations into existing locales
  - `i18n_delete.rb`: Handles deletion of translation keys
  - `i18n_rename.rb`: Handles renaming of translation keys

- **`locales/`**: Translation files (YML format)
  - 70+ locale files (e.g., `en-US.yml`, `de-DE.yml`)
  - Nested YAML structure with language codes as keys
  - Supports pluralization keys: `zero`, `one`, `two`, `few`, `many`, `other`

- **`countries/`**: Country-specific data (YAML/Ruby files)
- **`languages/`**: Language names and metadata (YAML/Ruby files)
- **`ordinals/`**: Ordinal number rules per locale (YAML/Ruby files)
- **`pluralization/`**: Pluralization rules per locale (YAML/Ruby files)
- **`transliteration/`**: Transliteration rules per locale (YAML/Ruby files)

### Key Concepts

**Locale Format**: Uses hyphenated format (e.g., `en-US`, `pt-BR`, `zh-CN`), not underscore format. Maps between simple language codes and locale codes:
- `DEFAULT_MAPPING` in `i18n.rb`: Maps `en` → `en-US`, `de` → `de-DE`, etc.
- `DEFAULT_COUNTRY_MAPPING`: Maps country codes to locale codes

**I18n Integration**: The gem extends the `i18n` gem by:
1. Loading all translation files from the `locales/`, `countries/`, `languages/`, etc. directories
2. Setting up fallback chains for locale resolution
3. Configuring pluralization and transliteration rules

**Pluralization Handling**: Different locales have different plural forms. The `I18nPatch` class handles converting plural keys appropriately for the target locale. Not all locales support all plural keys.

## Key Conventions

### Testing Patterns

- Tests use RSpec with simple `example "description"` blocks
- Specs test utility classes (`I18nPatch`, `I18nDelete`, `I18nRename`)
- Each spec file imports and tests a single class/module
- Use `expect(...).to eq(...)` for assertions

### Code Style

- Uses Shopify's `rubocop-shopify` config as base
- Target Ruby version: 3.4
- Excluded from rubocop: `pluralization/`, `transliteration/` directories (inherited from rails-i18n)
- No trailing commas in multiline arrays/hashes/arguments
- Files must start with `# frozen_string_literal: true`

### Naming Conventions

- Class names: `PascalCase` (e.g., `I18nPatch`)
- File names: `snake_case` (e.g., `i18n_patch.rb`)
- Locale codes: hyphenated (e.g., `en-US`, not `en_US`)

### Locale YAML Format

Translation files contain nested hashes with language codes as top-level keys:
```yaml
en:
  common:
    name: "Name"
    description: "Description"
```

Pluralization uses specific keys:
```yaml
en:
  items:
    one: "1 item"
    other: "%{count} items"
```

### Gem Dependencies

- `i18n`: Core internationalization library
- `rails-i18n`: Provides pluralization/transliteration rules (not loaded by default, opt-in with `require: false`)
- Development: `rspec`, `rubocop`, `rubocop-shopify`, `rake`, `dotenv`

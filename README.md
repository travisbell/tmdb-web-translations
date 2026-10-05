# tmdb-web-translations

Translation data and Ruby I18n support for the [TMDB](https://www.themoviedb.org/) website.

## How to contribute

Translate TMDB on [Weblate](https://weblate.themoviedb.org/projects/tmdb/).
If you plan to submit translations through a pull request, check with the project first to avoid duplicate submissions.

Review each entry against its English source and check its meaning in the film, television or interface context.
The [translation guide](translation-prompt.md) covers missing text and the checks to make before submitting it.
Website text is in `locales/`, country names in `countries/` and language names in `languages/`; each has its own `en-US.yml` reference.

For code changes, open a pull request explaining the problem and include relevant tests.
If you have questions, stop by [the forums](https://www.themoviedb.org/talk).

## Development checks

From the repository root, use Ruby 3.4 and the committed dependency lockfile:

```bash
bundle install
bundle exec rspec
bundle exec ruby script/locale_check.rb
bundle exec ruby script/pluralization.rb --check
```

CI runs the tests, YAML validation and plural-wrapper check on Ruby 3.4.

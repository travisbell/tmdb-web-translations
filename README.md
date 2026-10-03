# tmdb-web-translations

## How to contribute

TMDB translations are available on [Weblate](https://weblate.themoviedb.org/projects/tmdb/).
Coordinate translation imports with the project to avoid duplicate submissions through Weblate and pull requests.
For repository code changes, open a pull request with a reproduction and relevant tests.
If you have questions, stop by [the forums](https://www.themoviedb.org/talk).

## Development checks

Use Ruby 3.4 for development, matching the lint configuration and committed dependency lockfile.
This does not change the gem's declared minimum Ruby version.

```bash
bundle install
bundle exec rspec
bundle exec ruby script/locale_check.rb
bundle exec ruby script/pluralization.rb --check
```

`locale_check.rb` validates YAML syntax, duplicate keys, string keys and the single
locale root matching each filename. Pass files or directories to restrict its scope.
It exits with a nonzero status if validation fails.

## Translation maintenance

```bash
bundle exec ruby script/find_blanks.rb pt-PT
bundle exec ruby script/find_blanks.rb --component countries pt-PT
bundle exec ruby script/find_blanks.rb --component languages pt-PT
```

The blank finder compares against English and includes absent keys, nil, empty and
whitespace-only values, including entries in arrays. It skips empty English values,
non-string values and numeric configuration such as separators and format templates.
Human-readable number-unit labels are included. Plural categories follow the target
locale; missing target-only categories use the English `other` text as context.
A source `zero` message is included as an optional I18n zero override. Its output is a translation
worklist, not a full translation-quality or formatting audit.

The scripts that rewrite YAML validate it before writing. They create the temporary
file beside the destination and replace the destination with a single rename. A failed
replacement leaves the original file intact. Rename, copy, delete and global-rename commands validate and calculate all inputs
before writing, so a data error in a later file leaves earlier files unchanged.
A filesystem failure during writing can still leave earlier files updated: this is
not a transaction across the whole set. Commands leave unchanged data byte-identical. Rewriting YAML
can change quoting and comments, so inspect the diff before committing.

`rename-key.rb`, `copy-key.rb` and `rename_global.rb` preserve entire values, including
plural maps. Existing destinations and ancestor/descendant paths are refused instead
of silently discarding data. Identical source and destination paths are a no-op.
`delete-key.rb` removes the entire requested subtree, including nonempty maps.
Atomic replacement follows an existing symlink to its target; dangling symlinks are refused.

`script/pluralization.rb` generates Weblate wrappers from `config/pluralization.yml`.
Use `--check` in CI. New locales require a reviewed mapping to an existing rule in
`lib/weblate/pluralization/`; the generator does not substitute Rails rules.

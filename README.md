<p align="center">
  <a href="https://www.themoviedb.org/">
    <img src="https://www.themoviedb.org/assets/v4/logos/v2/blue_long_2-9665a76b1ae401a510ec1e0ca40ddcb3b0cfe45f1d51b77a308fea0845885648.svg" alt="The Movie Database (TMDB)" width="300">
  </a>
</p>

<h1 align="center">TMDB Web Translations</h1>

<p align="center">
  Translation data and Ruby I18n support for the TMDB website.
</p>

<p align="center">
  <a href="https://weblate.themoviedb.org/projects/tmdb/">Translate on Weblate</a>
  &middot;
  <a href="translation-prompt.md">Translation guide</a>
  &middot;
  <a href="https://www.themoviedb.org/talk">Community support</a>
</p>

## Contributing

### Translations

Submit new translations and corrections through the [TMDB Weblate project](https://weblate.themoviedb.org/projects/tmdb/).

Choose a language and component, then review each entry against its English source and its context on TMDB.
Preserve interpolation variables, links and HTML, and check the plural forms required by the target language.
Use Weblate comments to ask for context when a message is unclear.

Translation changes belong in Weblate. Use pull requests for code, tests and documentation.

### Code, tests and documentation

Open a pull request describing the problem, the resulting behavior and the checks you ran.
Include regression tests for bug fixes where appropriate.

The [translation guide](translation-prompt.md) provides reference material for reviewing locale files, investigating missing text and validating changes.

## Repository layout

| Location | Contents |
| --- | --- |
| [`locales/`](locales/) | Website labels, messages and locale formats |
| [`countries/`](countries/) | Country names |
| [`languages/`](languages/) | Language names |
| [`script/`](script/) | Translation maintenance and validation tools |
| [`lib/`](lib/) | Ruby I18n support and shared maintenance helpers |
| [`spec/`](spec/) | Translation and tooling tests |

Each translation component uses its own `en-US.yml` file as the English source reference.
Plural categories follow the target language.

## Development

Use Ruby 3.4 for the checks below, matching CI.
From the repository root, install dependencies using the committed `Gemfile.lock`:

```bash
bundle install
```

Then run the same checks as [CI](.github/workflows/test.yml):

```bash
bundle exec rspec
bundle exec ruby script/locale_check.rb
bundle exec ruby script/pluralization.rb --check
```

These checks cover the test suite, YAML validation and generated plural wrappers.
They complement contextual translation review; they do not establish that wording is correct.

## Questions and context

Ask about a translation in the corresponding Weblate entry.
For general questions about TMDB or contributing, visit the [community forums](https://www.themoviedb.org/talk).

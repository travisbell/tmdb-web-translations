# TMDB Locale Translation Prompt

Use this prompt when asking an AI to fill in blank translations for a locale file in this repository.

---

## Discovery

Before translating, run the following to see exactly which keys are blank and what their English values are:

```bash
ruby script/find_blanks.rb {LOCALE}
# e.g. ruby script/find_blanks.rb de-DE
```

This outputs every blank key alongside its English source string, which you can pass to an AI as the definitive list of work to do.

---

## Prompt

I need you to fill in blank translations in `locales/{LOCALE}.yml` for the TMDB (The Movie Database) website. Use `locales/en-US.yml` as the canonical source of truth.

Before starting, read a broad sample of the existing translated strings in the target locale file — especially short UI labels and user-facing messages — to understand the tone, formality, and vocabulary already in use. All new translations must be consistent with this style.

### Rules

**1. Only fill blanks — never overwrite existing translations.**
If a key already has a value in the target locale file, leave it exactly as-is.

**2. Never remove or blank out a key that already had a value.**
Even if the existing value looks like English, a format string, an abbreviation, or a technical term (e.g. "API", "DVD", "4K", "HD", "Trailer", "Clip"), it was intentionally placed there and must be preserved. Treat the original file as the baseline — any key with a value in the original must still have that same value when you are done.

**3. Do not fall back to the English value.**
If you cannot confidently translate a key, leave it blank/nil. The Rails i18n library automatically falls back to English at runtime. Writing an English string into a non-English locale file is always wrong.

**4. Skip keys with no English value.**
If the corresponding en-US key is also blank or nil, leave the target locale key alone.

**5. Preserve all format strings and locale-specific values.**
Values containing strftime or i18n format patterns (e.g. `"%B %Y"`, `"%d. %b %Y"`, `"%n %u"`, `"%{count} Folgen"`) must be preserved exactly if they already exist. If such a key is blank, only fill it in if you have a confirmed locale-appropriate format — do not blindly copy the English format string.

**6. Preserve complex structures.**
Some keys hold hashes rather than strings — for example pluralization keys (`one`, `other`, `few`, `many`, `zero`). If a key's value in the target locale is already a hash, do not replace it with a string.

**7. Do not change YAML line width or formatting.**
The file uses long lines for long strings. Do not introduce line wrapping, and do not re-serialize the entire file in a way that changes formatting of lines you did not touch. Make surgical edits only.

**8. Respect TMDB-specific terminology.**
This is a movie and TV database. Many English terms have specific, established translations that differ from their everyday meaning. Adhere to the glossary below rather than doing a literal translation.

**9. Match the tone and formality of existing translations.**
For German (de-DE): the existing translations use the informal **du** form (not Sie). For example: "Zu deinen Favoriten hinzufügen", "Deine Bewertung", "Bist du dir sicher?". All new German translations must follow this convention.

For other locales, determine the correct formality by reading the existing translations before starting.

---

### TMDB Glossary (English → German)

Use these established translations consistently. Do not invent alternatives.

| English | German |
|---|---|
| Award | Preis |
| Awards | Preise |
| Nomination | Nominierung |
| Ceremony | Zeremonie |
| Movie | Film |
| TV Show | Serie |
| TV Shows | Serien |
| Season (TV) | Staffel |
| Episode | Folge |
| Cast | Besetzung |
| Crew | Crew |
| Overview (plot synopsis) | Handlung |
| Tagline | Slogan |
| Backdrop | Hintergrundbild |
| Collection | Sammlung |
| Network | Sender |
| Rating | Bewertung |
| Watchlist | Watchliste |
| Keyword | Schlüsselwort |
| Discussion | Diskussion |
| Biography | Biografie |
| Director | Regisseur |
| Producer | Produzent |
| Actor | Darsteller |
| Creator | Urheber |
| Character (role) | Rolle |
| Season Regulars | Stammdarsteller |
| Stage Name | Künstlername |
| Homepage | Webseite |
| Content Rating | Altersfreigabe |
| Production Company | Produktionsunternehmen |
| Release | Veröffentlichung |
| Alternative Title | Alternativtitel |
| Original Title | Originaltitel |
| Translated Title | Lokaler Titel |

---

### What to skip (leave blank)

- Keys whose en-US value is blank or nil
- Keys you cannot confidently translate
- Date/time/number/currency format strings that are already blank (leave formatting decisions to locale specialists)

---

### Verification checklist before finishing

- [ ] Every key that had a value in the original file still has that same value
- [ ] No English text has been written into the locale file as a "translation"
- [ ] Format strings (`%B`, `%Y`, `%n`, `%{variable}`) are preserved or locale-appropriate
- [ ] No pluralization hash has been flattened to a string
- [ ] YAML is valid: `ruby -e "require 'yaml'; YAML.load_file('locales/{LOCALE}.yml')"`
- [ ] All tests pass: `bundle exec rspec`

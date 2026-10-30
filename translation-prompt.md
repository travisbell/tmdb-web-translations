# TMDB Translation Guide

Use this guide to fill in missing translations in this repository.
Review entries individually against their English source and the context in which they appear on TMDB.

---

## Discovery

Before translating, run the following to see exactly which keys are blank and what their English values are:

```bash
bundle exec ruby script/find_blanks.rb {LOCALE}
# e.g. bundle exec ruby script/find_blanks.rb de-DE
# For a different component:
bundle exec ruby script/find_blanks.rb --component countries {LOCALE}
bundle exec ruby script/find_blanks.rb --component languages {LOCALE}
```

This lists source-backed text blanks, including absent keys and entries in arrays. It skips numeric configuration and empty English source values, but includes displayed unit labels. Plural categories follow the target locale; for a target-only category, the English `other` text supplies context. A listed `zero` message is an optional I18n override. Review date/time formats separately; this worklist does not verify translation quality or application context.

---

## Translation workflow

Fill in missing translations in `{COMPONENT}/{LOCALE}.yml` for the TMDB (The Movie Database) website. Use `{COMPONENT}/en-US.yml` as the source reference. Replace `{COMPONENT}` with `locales`, `countries` or `languages`, and `{LOCALE}` with the exact locale code, such as `pt-PT` or `de-DE`.

Before starting, read existing labels and messages to understand the locale's tone and vocabulary. Then work through the entries one by one, including every applicable plural form. Compare each translation with the English source and check its meaning in the film, television or interface context. Read Weblate comments and check the corresponding TMDB page when needed; ask for context if the meaning is still unclear.

For a full review, also examine existing translations one by one and record proposed corrections separately. Do not treat the existing wording or glossary as proof that a translation is correct.

### Rules

**1. Keep missing-text changes separate from corrections.**
If a key already has a value in the target locale file, leave it exactly as-is.

**2. Never remove or blank out a key that already had a value.**
Even if the existing value looks like English, a format string, an abbreviation, or a technical term (e.g. "API", "DVD", "4K", "HD", "Trailer", "Clip"), leave it unchanged in this task. Do not assume that an existing translation is correct: flag suspected errors for a separate review. Treat the original file as the baseline — any key with a value in the original must still have that same value when you are done.

**3. Do not fall back to the English value.**
If you cannot confidently translate a key, leave it blank/nil and report the uncertainty. This repository configures I18n fallbacks to `en-US`; a fallback is not evidence that the target translation is complete. Do not use untranslated English as a substitute for translation. Identical text can be correct for names, abbreviations, shared vocabulary and technical terms; assess each case in context.

**4. Skip keys with no English value.**
If the corresponding en-US key is also blank or nil, leave the target locale key alone.

**5. Preserve all format strings and locale-specific values.**
Values containing strftime or i18n format patterns (e.g. `"%B %Y"`, `"%d. %b %Y"`, `"%n %u"`, `"%{count} Folgen"`) must be preserved exactly if they already exist. If such a key is blank, only fill it in if you have a confirmed locale-appropriate format — do not blindly copy the English format string.

**6. Preserve complex structures.**
Some keys hold hashes rather than strings — for example pluralization keys (`one`, `other`, `few`, `many`, `zero`). If a key's value in the target locale is already a hash, do not replace it with a string. Use the target locale's reviewed plural rule, not every English category. For a missing target-only category listed by the blank finder, use the English `other` text as context and write the appropriate target-language form. Preserve array positions and structural nulls; do not turn `nil` into the literal text `"nil"`.

**7. Do not change YAML line width or formatting.**
The file uses long lines for long strings. Do not introduce line wrapping, and do not re-serialize the entire file in a way that changes formatting of lines you did not touch. Make surgical edits only.

**8. Respect TMDB-specific terminology.**
This is a movie and TV database. Many English terms have specific, established translations that differ from their everyday meaning. Use a reviewed glossary for the target locale and check the meaning in its film, television or interface context. If a glossary entry appears incorrect or ambiguous, flag it with evidence rather than spreading the error.

**9. Match the tone and formality of existing translations.**
For German (de-DE): the existing translations use the informal **du** form (not Sie). For example: "Zu deinen Favoriten hinzufügen", "Deine Bewertung", "Bist du dir sicher?". All new German translations must follow this convention.

For other locales, determine the correct formality by reading the existing translations before starting.

**10. Preserve interpolation, HTML and links.**
Keep interpolation variable names such as `%{count}`, `%{title}` and `%{media}` exactly as required by the source. Preserve HTML structure, attribute names and link destinations; translate user-visible text, including translatable attribute values such as `alt` or `title`. Check the YAML escaping of quotes and special characters. Do not infer what an ambiguous variable refers to without context.

**11. Report missing context and the result of the checks.**
Use the key, source text, Weblate comments and the corresponding TMDB page to resolve ambiguity. If the context is still insufficient, leave the text blank and list the question. Report what you translated, what remains unresolved and which checks you actually ran. Never report a check as passed if it was not executed.

---

### TMDB Glossary (English → German)

The following German glossary is a starting point for de-DE only. Review ambiguous entries in context; do not apply it to another locale or treat it as proof that an existing term is correct.

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
- Date/time/number/currency format strings without a confirmed locale-appropriate value (leave unresolved formatting decisions to locale specialists)

---

### Verification checklist before finishing

- [ ] Every key that had a value in the original file still has that same value
- [ ] No untranslated English has been substituted for a translation; justified identical text has been reviewed in context
- [ ] Format strings (`%B`, `%Y`, `%n`, `%{variable}`) are preserved or locale-appropriate
- [ ] Interpolation names, HTML tags and attributes, and link destinations match the source requirements
- [ ] No pluralization hash has been flattened to a string
- [ ] Plural categories follow the target locale; array positions and structural nulls are preserved
- [ ] YAML syntax, keys and locale root are valid: `bundle exec ruby script/locale_check.rb {COMPONENT}/{LOCALE}.yml`
- [ ] The diff contains only intended edits; remaining blanks and uncertainties are reported
- [ ] All tests pass: `bundle exec rspec`

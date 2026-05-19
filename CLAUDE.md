# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Jekyll 3.8 static site for Living Savior Lutheran Church, deployed to `livingsaviorlutheran.org`. Ruby 2.6.5. No JavaScript build step — `js/` and `css/` are plain static assets.

## Commands

```bash
bundle install            # first-time setup
bundle exec jekyll serve  # local dev server with livereload (per _config.yml)
bundle exec jekyll build  # produces ./_site (what CI deploys)
```

No test suite, no linter. CI (`.github/workflows/jekyll.yml`) only runs `jekyll build` and deploys via FTP.

## Deployment

GitHub Actions auto-deploys on:
- `push` to `master` → `/public_html/` (production)
- `pull_request` → `/preview.livingsaviorlutheran.org/` with a `Disallow: /` robots.txt injected into `_site/`

FTP credentials are GitHub secrets `FTP_USERNAME` / `FTP_PASSWORD`. There is no staging environment beyond PR previews.

## Architecture worth knowing

### The bulletin/insert filename contract (`_plugins/Announcements.rb`)

This is the one piece of non-obvious logic in the repo. The `Announcements::Generator` plugin runs at build time and:

1. Finds every static file in `bulletin/` (tagged via the `bulletin: true` default in `_config.yml`).
2. Strips all non-numeric characters from each filename and takes the **first 6 digits** as an `MMDDYY` date. Example: `022526 Midweek Lenten web.pdf` → `022526` → Feb 25, 2026.
3. Sorts bulletins by that date, reverses (newest first), and exposes them as `site.data.bulletins` — consumed by `bulletin/index.html` (which embeds the newest) and `announcements/index.html` (sidebar link).
4. For each bulletin, constructs an announcement-insert path `/inserts/<MMDDYY>.pdf` using the same stripped numeric name.

**Implications when adding new bulletins (the most common task in this repo — see recent commits):**
- Bulletin PDFs in `bulletin/` **must** start with 6 digits that parse as `MMDDYY`. Extra text after is fine (`…late web.pdf`, `… Midweek Lenten web.pdf`, `… Ash Wed web.pdf`).
- The matching announcement insert in `inserts/` must be named exactly `<MMDDYY>.pdf` (no extra text).
- An unparseable bulletin filename **raises and stops the build** (`raise e` in the plugin). A missing insert only logs a warning.

### Collections

Defined in `_config.yml`:
- `ministries` (content in `_ministries/<name>/index.md`) — `output: false`, so these aren't standalone pages; they're rendered by iterating `site.ministries` elsewhere.
- `announcements` (content in `announcements/`, both `.html` directories and loose PDFs) — also `output: false`. The generator parses each announcement's `date` front-matter into a `Date` object; a bad date stops the build.

### Other data sources

- `_data/newsletters.csv` — a two-column CSV (`name,url`) driving the "Latest Newsletter" sidebar. Add a row here when a new Mailchimp newsletter ships.
- `newsletter/files/` — archive of past newsletter PDFs, auto-flagged `newsletter: true` via the `_config.yml` defaults scope.

### Layouts

`default.html` is the common page frame (header include, hero slider, breadcrumb from URL parts, footer include). Most pages use `layout: default`. `bulletin/index.html` embeds the current bulletin via a Google Docs viewer iframe.

## Conventions

- Don't rename or reformat existing bulletin/insert PDFs — the filename **is** the date key.
- When editing `_config.yml`, restart the dev server (Jekyll does not hot-reload it).
- CSS lives in `_sass/` (compiled) and `css/` (static); no preprocessor pipeline beyond Jekyll's built-in sass-converter.

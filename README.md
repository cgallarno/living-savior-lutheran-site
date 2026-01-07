# Living Savior Lutheran Church Site

## Content updates

### Announcements
- Add a new markdown file under `_announcements/` with a descriptive filename (for example `2025-11-28-deck-the-halls.md`).
- Include front matter with a `date` field (YYYY-MM-DD). The date is used for sorting and for the "Posted" label.
- Write the announcement body in Markdown to support links and inline formatting.

Example:
```markdown
---
date: 2025-11-28
title: Deck the Halls of Living Savior!
---

**Deck the Halls of Living Savior!** We are recruiting holiday helpers. Sign up here: <https://example.com>.
```

### Inserts
- Place insert files (PDFs, images, etc.) in the `inserts/` directory.
- Link to them from the appropriate page using the relative path (for example `/inserts/filename.pdf`).

### Bulletins
- Upload bulletin files to the `bulletin/` directory.
- Update `_data/bulletins.csv` with the bulletin name and file path so the site can link to the latest bulletin.

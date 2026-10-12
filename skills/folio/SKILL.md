---
name: folio
description: Find and download a book or paper with the folio CLI (open-access PDFs straight from arXiv, DROPS and other publishers; otherwise LibGen search, downloads via Anna's Archive, LibGen and IPFS). Use when the user asks to find, fetch, download or get a PDF/EPUB of a specific book or paper by title, author, ISBN, DOI, arXiv id or link.
---

# folio

`folio` downloads open-access papers from their publisher, and otherwise
searches LibGen and downloads a file by md5, checking the md5 of what it
saved. Only `search` and `get` are for agents; plain `folio <query>` opens an
interactive prompt, so never run it without a subcommand.

Anna's Archive and LibGen hold a lot of copyrighted material. Use folio for what
the user has the right to access (public domain, openly licensed, copies they
own). If a paper is openly available (arXiv, the publisher's open-access page),
get it that way, as below.

## Open access first

With a DOI, an arXiv id or a link to the paper's page, try the publisher before
any search:

```sh
folio get 10.4230/LIPIcs.ECOOP.2023.9 -o ~/papers
folio get arXiv:1706.03762 -o ~/papers
folio get https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ECOOP.2023.9
```

stdout is the saved path. Exit code 1 means the page offers no open PDF
(paywalled, or the publisher blocks scripts): go on to the steps below. If you
know the paper has an arXiv version, pass that id rather than the journal DOI.

`folio search --json <doi>` also lists the open-access copy first: it has an
empty `md5`, a `url` (the PDF) and a `page`, and `page` is what `folio get`
takes.

## Steps

1. Search with the title words plus the first author's surname, as JSON:

   ```sh
   folio search --json -n 10 attention is all you need vaswani
   ```

   Or pass a DOI directly, bare or as a `doi.org/…` URL with or without
   `http://` or `https://`: `folio search --json 10.1007/978-3-540-75183-0_13`.
   `doi:` and legacy `dx.doi.org` prefixes also work. A DOI can have metadata
   in LibGen without a downloadable file, in which case no result is returned.

   Each result has `md5`, `title`, `author`, `year`, `lang`, `size`, `ext` and
   `article`. Exit code 1 means no results: drop words (subtitle, edition,
   punctuation) and retry before giving up.

2. Narrow with flags instead of reading long lists: `--ext pdf,epub`,
   `--year 2017` or `--year 2015-2020`, `--lang English`, `--books` or
   `--articles`. LibGen often files arXiv papers as books, so do not use
   `--articles` for them. Sci-Hub is not queried directly.

3. Pick one result. Match title and author first. Unless the user said
   otherwise, prefer the format they asked for (PDF for papers, EPUB or PDF for
   books), the edition they named or else the newest, English or the query's
   language, and skip translations, summaries, solution manuals and archives
   (`gz`, `zip`, `rar`) unless asked. If two candidates are really different
   works or editions and the choice matters, ask the user.

4. Download, choosing the folder the user wants (default `$FOLIO_DIR` or
   `~/Downloads`):

   ```sh
   folio get 18e1b007a1dab45b30cc861ba2dfda25 -o ~/papers
   ```

   stdout is the saved path, one per md5 (several md5s can go in one call).
   Progress and per-source errors go to stderr. Files are named like
   `2017-vaswani-attention-is-all-you-need.pdf`.

5. If `get` exits 1, every source failed for that md5: try the next best
   candidate from step 1. Report the saved path to the user, not the md5.

## Notes

- LibGen mirrors (`libgen.li`, `.bz`, `.gl`, `.vg`, `.la`) are tried in turn
  automatically. If all fail, the sites are down or blocked; say so rather than
  retrying in a loop.
- `folio info <md5>` and `folio torrent <md5>` need an Anna's Archive record,
  which is members-only (`AA_KEY`) for most files.
- `folio --help` and `folio search --help` list every flag.

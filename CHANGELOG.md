# Changelog

## [Unreleased]

### Changed
- Version normalized to three-part semver (4.0.0).
- Frontmatter normalized: environment-based `compatibility`, `metadata.author`, `phases: 6`; the validation scripts that use ReadSightPy now declare Python 3.10+.
- Reference files are read by relative path from the skill folder instead of GitHub raw URLs.
- Long dashes replaced with hyphens across all documentation.
- Section canon: `WHEN NOT TO USE`, `OUTPUT CONTRACT`; pre-flight and language detection no longer use negative stage numbers.
- Canonical placeholder vocabulary documented: `[VERIFY: ...]`, `[DATA NEEDED: ...]`, `[N]`, `[illustrative]`.
- Install folder documented as `human-ai/` to match the skill name.

## [4.0.0] - 2026-07-12

### Added
- Self-contained `SKILL.md`: every critical rule is embedded, deep data lives in `shared/`.
- Morphological validator, ReadSightPy readability check, ZeroGPT detection script.
- Clause-based rhythm system replacing word-count rhythm.
- Pre-flight check with an already-human guard.
- Self-evaluation loop: Quality Score out of 100 plus a single re-loop.
- `cultural-matrix.md`: per-language cultural norms wired into the pipeline.
- Five new scenarios (15 total), `CONTRIBUTING.md`, `KNOWN_LIMITATIONS.md`, `EVAL.md`, CI.

### Changed
- Scenario files unified under one naming scheme.
- Preservation mode removed from `SKILL.md` and kept in the README only.

## [3.0.0] - 2025-06-21

### Architecture Overhaul
- Complete repository restructure: MindFluence-style architecture
- `shared/` directory: single source of truth for all language data (no duplication)
- `scenarios/` directory: 10 task-specific playbooks
- `examples/` directory: 8 annotated before/after examples
- Removed 7 old sub-skill directories (anti-ai-cleanup/, human-writing-editor/, etc.)

### Language Expansion
- Added 6 new languages: German (de), French (fr), Spanish (es), Portuguese (pt), Italian (it), Polish (pl)
- Total: 9 languages with full AI markers, burned words, tone profiles, specificity ladder, rhythm tables
- Language template (`shared/language-template.md`) for adding new languages

### Policy Unification
- **Em-dash policy:** Unified across all languages - em-dash = AI tell, replace always
- **Skip policy:** Resolved contradiction - stages are sequential, skip with declared reason only
- **Verb forms:** Unified infinitives in burned-word lists across all files

### Fixes
- Fixed: "Two rules" → "Three rules" (sentence length rules)
- Fixed: RU «неділя» → «воскресенье» (translation-humanizer)
- Fixed: Version 3.0/3.1 inconsistency → unified to 3.0
- Fixed: `technical-doc.md` scenario added to README architecture trees
- Fixed: Italian `[VERIFICARE]` flag added to SKILL.md verify list
- Fixed: Russian example rhythm annotations (incorrect word counts)
- Fixed: "Phase" → "Stage" terminology in seo-article.md
- Fixed: Replacement examples added for ES, PT, IT, PL

### Documentation
- Bilingual README (EN + RU), MindFluence-style
- Complete architecture tree in both READMEs
- All cross-references verified

### Project Hygiene
- Added LICENSE (MIT)
- Added .gitignore
- Added CHANGELOG.md (this file)
- 28 files, 1807 lines (down 38% from 2895 despite 3× functionality)

---

## v2.x (pre-3.0) - Legacy

Original 7-sub-skill structure. 3 languages (EN, RU, UK). Individual SKILL.md per sub-skill with significant content duplication. Deprecated by v3.0 architecture overhaul.

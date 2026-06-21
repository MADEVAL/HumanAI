# Changelog

## v3.0 - 2025-06-21

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

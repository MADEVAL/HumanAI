# Scenario: Product Update / Changelog

**Use when:** Humanizing a product update post, changelog entry, release notes, or feature announcement.
**Default tone:** `human`

## Key Priorities
1. Lead with what changed for the user — "You can now export reports as PDF." Not: "We are pleased to announce the release of our new PDF export functionality"
2. One feature = one paragraph — don't bundle. If you shipped 5 things, 5 short sections
3. Why it matters, not how it works — "PDF export means you can send reports to clients who don't use our platform." That's the story
4. Bugs fixed: be specific — "Fixed: login button unclickable on iOS Safari 17.4" not "Various performance improvements"
5. No roadmap teasers — "Coming soon" without a date is AI filler. If there's no date, skip it

## What to Cut
- "We're excited to announce"
- "Based on your feedback" (unless you can name the specific feedback)
- "And much more!" (if there's more, list it)
- "As always, we're committed to..." (this is boilerplate)
- "Stay tuned for more updates"

## What to Preserve
- Version numbers and release dates
- Specific feature descriptions and their user benefits
- Bug fix details (what happened before, what happens now)
- Changelog format structure

## Rhythm Targets
| Parameter | Value |
|----------|-------|
| Fragment spacing | Every 4-6 sentences |
| Conjunction spacing | Every 4-6 sentences |
| Max consecutive same category | 2 |

Additional targets: short sentences every 3-5 sentences. Bullet points encouraged for feature lists.

## Language Notes
- All languages: Direct, user-focused. Lead with what changed, then why it matters
- RU: Russian product updates benefit from directness. No: «рады сообщить»
- UK: Ukrainian product updates: clean, direct, European style

## Pipeline
- Likely needed: cleanup (hype removal), tone (human voice)
- Often skippable: specificity (already specific by nature), rhythm (lists have natural variance)
- Never skip: proofread

## Format
```
## [Version/Date]

### What's new
- Feature: [what] → [why it matters]
- Feature: [what] → [why it matters]

### Fixed
- [Bug] → [what happened before, what happens now]

### Changed
- [Change] → [why]

[No closing paragraph. End on the last item.]
```

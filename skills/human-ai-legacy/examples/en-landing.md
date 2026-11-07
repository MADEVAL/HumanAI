# Example: EN Landing Page

## BEFORE (AI-generated)

Welcome to TaskFlow - the revolutionary project management platform for modern teams. Our robust, cutting-edge solution leverages AI to optimize workflows and facilitate seamless collaboration across your entire organization. With best-in-class features and an intuitive, user-friendly interface, TaskFlow empowers teams to achieve unprecedented levels of productivity and efficiency. Whether you're a small startup or a large enterprise, our comprehensive platform provides everything you need to streamline operations and drive growth. Get started today and experience the future of work. Our mission is to transform how teams work together in the digital age. Learn more about our innovative approach and join thousands of satisfied customers who have already made the switch.

**AI tells:** "Welcome to" · "revolutionary" · "robust, cutting-edge" · "leverage" · "optimize" · "seamless" · "best-in-class" · "intuitive, user-friendly" (adj pileup) · "empowers" · "unprecedented" · "comprehensive" · "streamline" · "Get started today" · "Our mission is" · "Learn more" · "thousands of satisfied customers" (vague social proof)

---

## AFTER (human-ai v3)

```
[LANG: en]
[TONE: landing]
[PIPELINE: cleanup → specificity → tone → rhythm → proofread]

Your team's tasks, deadlines, and files. In one place. Not six.

TaskFlow replaces Slack threads, spreadsheet trackers, and "where is that doc?" emails. Most teams set it up in an afternoon. Monday morning, everyone knows what to do.

Teams using TaskFlow ship projects 30% faster. Not because they work harder. Because nobody spends Tuesday figuring out what changed over the weekend.

Plans start at $12 per person. No setup fee. Cancel anytime. Your data exports in one click - we don't hold it hostage.

[Start building →]

---
[CHANGELOG]
- Opener: "Welcome to TaskFlow" → hook: "Your team's tasks. In one place."
- Burned words killed: revolutionary, robust, cutting-edge, leverage, optimize, seamless, best-in-class, intuitive, user-friendly, empower, unprecedented, comprehensive, streamline, innovative (14x)
- Social proof: "thousands of satisfied customers" → "30% faster" with mechanism
- CTA: "Get started today" → "Start building →"
- "Our mission is" → deleted
- "Learn more" → deleted
- "Whether you're a small startup..." fake balance → deleted
- Tone: landing - tight, benefit-focused, confident
- Rhythm: 9w → 4w → 22w → 9w → 9w → 16w → 6w → 3w → 17w
```

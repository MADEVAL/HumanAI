# Already-Human Text (should NOT be modified)

Yesterday I fixed a bug that had been in our codebase for two years. Two years. Nobody noticed because it only happened when three specific conditions aligned: a user uploaded a PDF, on a Tuesday, after 4PM server time. I'm not joking. The datetime parsing logic had a timezone offset that was only wrong during a 4-hour window once a week.

I found it by accident. I was looking at something else entirely and noticed a log line that looked slightly off. Just slightly. The timestamp said 16:03 and the event it was recording happened at 17:03. One hour. Invisible to every monitoring dashboard we had because the dashboard corrected for timezone. The log didn't.

Anyway, it's fixed now. Took four minutes. The investigation took four hours. That's the ratio I've come to expect.

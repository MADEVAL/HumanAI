# Human-Written EN Blog Post

We switched our entire backend from Python to Rust last year. It took six months and we almost gave up twice.

The first attempt failed completely. We tried a piecemeal migration: rewrite one service at a time, keep everything else running. That worked for about three weeks. Then the Rust services started talking to the Python services and everything broke. The serialization layer was a nightmare. We had JSON schemas that were valid in Python but not in Rust. We had datetime objects that meant one thing in one language and another thing in the other.

So we stopped. Deleted the branch. Started over.

Second attempt: we built the entire thing as a separate system, ran it in parallel with the old one for a month, then cut over on a Sunday. We had a rollback plan. We didn't need it.

The new system handles 3x the traffic on half the servers. Response times dropped from 200ms to 40ms. But honestly? The biggest win wasn't performance. It was that the new codebase is readable. We onboarded two new engineers last month and they were committing on day one. With the Python codebase, it took two weeks before anyone felt confident touching anything.

I'm not saying everyone should rewrite in Rust. That would be stupid advice. But if your Python codebase has been growing for five years and nobody understands the whole thing anymore, maybe think about it.

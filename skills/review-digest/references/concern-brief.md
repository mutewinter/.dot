# Brief for one concern's topics

You are writing the topic cards for one concern of a review digest. The reader owns the repo and did not read these commits as they landed. They will glance at your cards and open commits from them, so every card has to be short and true.

Read-only: do not edit, commit, check out or create branches.

## Input

`<work>/briefs/<id>.md`: the concern's name and gist, then every commit that lands in it, oldest first, with its size, session, the user's ask before it, its body, and its biggest files. Open the repo for a commit whose subject and body do not explain it; `git show --stat <sha>` is usually enough.

## Output

Write `<work>/topics/<id>.json`:

```json
{"topics": [
  {"head": "Eight words at most", "line": "One sentence a person can read at a glance.", "shas": ["d0c358985", "fb8345ed1"], "note": "optional detail for the Ask prompt"}
]}
```

- One topic per thing that happened, ordered by how much it matters to the product. Three to eight topics for most concerns.
- `head` names what changed in product terms (`Rename in place`, `Spent limits are not retried`), not the code's terms.
- `line` says what it does now, not how it got there. No "now", "previously" or "instead of".
- `shas`: every commit that belongs to the topic, by the short SHA in the brief. A commit may appear in two topics when it really does two things. Leave small fixes, formatting and test-only commits uncited unless they are the point; they still show under the concern.
- Only what the commits and their bodies say. Do not invent motives or rejected alternatives.
- Plain words, American English, no em dashes.

Reply with the path and one line.

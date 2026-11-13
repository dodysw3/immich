# Video transcription lexical ranking foundation

This standalone utility is not yet connected to search or indexing. It searches spoken transcript text only, not interpretations, translations, embeddings or meanings. Normalization uses Unicode NFKD, Unicode 16.0 default full case folding and combining-mark removal; token boundaries are Unicode letters and numbers. Highlight offsets are UTF-16 offsets into the unchanged original text. This policy is not PostgreSQL `f_unaccent`: indexing and query verification must use the same normalization policy.

Windows contain up to three adjacent segments, at most 30 seconds and at most two seconds between segments; a single segment is always retained even when long. A SHA-256 revision covers ordered segment text and timestamps, independently of run identity. Timestamps are segment starts, not word alignment. Overlapping windows with identical matched token occurrences are deduplicated; repeated occurrences remain separate.

Exact ordered phrases rank before exact all-token matches, then full-coverage spelling matches, then partial coverage. Query token multiplicity is preserved. Default coverage, proximity and spelling weights are 0.50, 0.30 and 0.20; default minimum coverage is 1, fuzzy threshold 0.60, and minimum fuzzy query-token length 4. Scores are weighted means within tiers; ties use timestamp and passage identity. Similarity must be supplied per token from PostgreSQL `strict_word_similarity(query_token, passage_token)` or an equivalent source: this utility does not emulate PostgreSQL trigram rules. Candidate retrieval must not silently truncate results. The verifier uses polynomial rectangular assignment, O(Q²(P + Q)) for Q query and P passage tokens; callers still need explicit query/resource limits and must return an error when they cannot verify completely, never a partial page.

The future viewer must honor the existing autoplay preference and use the matching segment start; this foundation does not change playback.

## Implemented API (2026-11-12, `video-transcription-search`)

The ranking utility is now served by `POST /api/search/transcription` (one
result per video with `bestMatch`, bounded `additionalMatches`, `matchCount`,
opaque cursor) and `POST /api/search/transcription/moments` (paginated
additional moments for one video). Queries are 1-200 characters, normalized
with the same policy as transcripts (NFKD + case folding + mark removal);
access filters (owner/partner, visibility, taken-date, favorite, rating,
location/camera, people, tags, albums, stacking) are applied inside the
candidate SQL. Cursors embed the ranking-configuration hash: an admin tuning
change invalidates in-flight cursors instead of mixing profiles.

Tuning lives in admin system config (`transcriptionSearch`): coverage /
proximity / similarity weights (finite, non-negative, positive total),
minimum token coverage in (0, 1], fuzzy threshold in [0, 1], minimum fuzzy
token length, and the additional-moments limit. Changes apply to subsequent
searches immediately — no retranscription, no re-indexing. `explain: true`
adds per-match score components (`coverage`, `proximity`, `similarity` — the
exact inputs of the weighted score) and coverage counts scoped to the
caller's authorized videos (never library-wide counts).

Default fuzzy threshold is **0.50** (measured, not the planned 0.60):
pg_trgm `strict_word_similarity` scores realistic single-character typos in
5+ character words at 0.50-0.79 (bording/boarding 0.545,
anouncement/announcement 0.786, menontn/menonton 0.545) while weak pairs
score ~0.375 (car/carpet, bor/boring); 0.60 would have excluded real typos.

Query plans at synthetic scale (10k videos, 50k passages, 400k token rows,
local PG 14 / pg_trgm): selective exact queries use the GIN full-text index
(`Bitmap Index Scan on idx_transcript_passage_fts`, 5.8 ms); fuzzy probes use
the trigram GIN index (`idx_transcript_passage_token_trgm`), 120-135 ms for
full-universe probes. Storage at that scale: 27 MB passages (328 B/row) +
56 MB tokens (140 B/row) + 32 kB index-state — roughly 8 KB of derived
storage per video per 5 windows; expect ~1-2 GB per 50k-video library with
full transcripts, all rebuildable from `asset_metadata` alone.

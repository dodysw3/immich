## ADDED Requirements

### Requirement: Dry-run scan CLI
A dry-run CLI SHALL accept an asset id and configuration file, execute the full sampling/grouping pipeline, and write a manifest (resolved config + hash, versions, every candidate and sample with selection reason, every detection with identity assignment or rejection reason, timings, outcome) plus a contact sheet (timestamped frames with identity-colored boxes and per-identity crop cards) WITHOUT writing anything to the library.

#### Scenario: Tuning experiment is side-effect-free
- **WHEN** a config experiment is run via the dry-run CLI
- **THEN** library tables are unchanged and the manifest + contact sheet are sufficient to judge the config

### Requirement: Superset detection cache
The tuning harness SHALL support caching extracted frames and per-frame detections (boxes, scores, embeddings) keyed by frame content hash, so any frame-budget-bounded picker or grouping policy can be simulated offline in seconds without re-decode or re-detection.

#### Scenario: Policy sweep without ML calls
- **WHEN** picker/grouping parameters change within the cached superset
- **THEN** the simulation replays from cache with zero ffmpeg and zero ML calls

### Requirement: Corpus metrics
Each tuning run SHALL report against owner-reviewed ground truth: recall, false merges, splits, new identities per attempt, attempts per unique identity, decode ms, ML ms — compared at equal work budgets (equal attempts, not equal wall time).

#### Scenario: Equal-budget comparison
- **WHEN** adaptive and uniform policies are compared
- **THEN** both consume the same number of analyzed frames so quality differences are not confounded by speed

### Requirement: Baseline corpus seeded
The reviewed corpus SHALL start with asset 79962286 (owner-verifiable family video, 908-detection superset already cached) and grow to 15+ videos spanning short clips, gatherings, moving cameras, crowds, long recordings, brief appearances, low light, 4K, and difficult encodings.

#### Scenario: First corpus entry reviewed
- **WHEN** the owner completes identity-labels.csv for 79962286
- **THEN** grouping-threshold sweep results (35/28/19/16 at 0.45/0.5/0.55/0.6) are scoreable against the true person list

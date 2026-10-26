## ADDED Requirements

### Requirement: Faces-in-this-video strip
The video viewer SHALL show a strip of per-identity cards for the asset's video faces — crop thumbnail, name or Unknown label, and "First observed m:ss" — including identities not assigned to any global person.

#### Scenario: Unknown person surfaces for review
- **WHEN** a video identity has no global person assignment
- **THEN** it still appears in the strip labeled Unknown, because it never entered global recognition

### Requirement: Click-to-seek on face observations
Clicking a face card or its observation marker SHALL seek playback to that sighting's timestamp (decoded presentation time) through the existing viewer seek path.

#### Scenario: Click jumps to first appearance
- **WHEN** the owner clicks a face first observed at 4.3s
- **THEN** playback seeks to 4.3s and resumes from there

### Requirement: Honest observation markers
Timeline markers SHALL represent sparse observed sightings ("seen at"), not continuous presence; no box or marker SHALL persist between sightings or imply tracking.

#### Scenario: Marker does not imply continuous presence
- **WHEN** an identity has sightings at 1.2s and 9.8s only
- **THEN** exactly two markers render with no connecting presence band

### Requirement: Coverage visibility
The viewer SHALL surface scan coverage (sampled timeline fraction, outcome, staleness vs current config) and expose an "Analyze more" action that resumes/deepens the scan with an explicit budget increase.

#### Scenario: Partial coverage is visible
- **WHEN** a run ended `budget_exhausted` at 60% timeline coverage
- **THEN** the strip shows that state and offers Analyze more

## ADDED Requirements

### Requirement: Info icon opens full-metadata modal
In the asset viewer info panel, the `(i)` icon next to the filename SHALL open the full-metadata modal (both images and videos) instead of only revealing the file path inline. The icon remains visible to owners only.

#### Scenario: Image owner opens modal
- **WHEN** the owner clicks the `(i)` icon on an image
- **THEN** the modal opens showing the asset's full stored metadata

#### Scenario: Video owner opens modal
- **WHEN** the owner clicks the `(i)` icon on a video
- **THEN** the modal opens and includes the Streams section with video and audio stream details

### Requirement: Grouped, type-adaptive sections
The modal SHALL group the metadata into labeled sections — File (path, folder link, size, orientation, modified), Camera/Exif (make/model/lens, exposure, ƒ, ISO, focal length, rating, dates/timezone, description, EXIF keyword tags), Photo/Video properties (dimensions, fps, color profile, colorspace, bits per sample), Streams (video + audio; video assets only), and GPS (lat/lon, city/state/country). Fields with no stored value SHALL be omitted rather than rendered empty.

#### Scenario: Streams only for video
- **WHEN** the modal opens for an image
- **THEN** no Streams section is rendered

#### Scenario: Absent sections hidden
- **WHEN** a video has no stored stream rows (pre-stream extraction)
- **THEN** the Streams section is hidden and the rest of the modal renders normally

### Requirement: Path stays owner-only
The File section's server path and folder link SHALL remain owner-visible (inherent: the modal itself is owner-only) and SHALL preserve the existing "go to folder" navigation behavior that the retired inline reveal provided.

#### Scenario: Folder link preserved
- **WHEN** the owner opens the modal and clicks the path's folder link
- **THEN** navigation goes to the parent folder in the folders view, as the old inline path link did

### Requirement: Copy as JSON
The modal SHALL offer a copy-as-JSON action that copies the endpoint's payload verbatim (all stored fields, including nulls), so power users can inspect exactly what the server has.

#### Scenario: Copy matches endpoint payload
- **WHEN** the owner uses copy-as-JSON
- **THEN** the clipboard contains the `GET /api/assets/:id/media-metadata` response body unchanged

import type { TranscriptionMatchDto, TranscriptionMomentsResponseDto, TranscriptionSearchItemDto } from '@immich/sdk';
import { SvelteMap, SvelteSet } from 'svelte/reactivity';

/** Per-video Transcription search presentation, kept alongside the asset-only gallery data. */
export type TranscriptionPresentation = {
  bestMatch: TranscriptionMatchDto;
  /** Moment the card and viewer seek target point at; switches when another moment is selected. */
  selected: TranscriptionMatchDto;
  /** Distinct additional moments beyond the best match (deduped by passageId). */
  additionalMatches: TranscriptionMatchDto[];
  /** Total distinct matching moments for this video. */
  matchCount: number;
  /** True once every moment page for this video has been loaded. */
  momentsComplete: boolean;
};

/**
Presentation map for Transcription search results, keyed by asset id. Lives
next to the asset-only gallery list so cards can show matched frames and
snippets and the viewer can seek to the selected moment — without mutating
AssetResponseDto or duplicating the video in the grid.
*/
export class TranscriptionPresentationManager {
  #matches = $state(new SvelteMap<string, TranscriptionPresentation>());

  get matches() {
    return this.#matches;
  }

  get(assetId: string) {
    return this.#matches.get(assetId);
  }

  /** Stores one search page; one entry per video, selected moment = best match. */
  loadPage(items: TranscriptionSearchItemDto[]) {
    for (const item of items) {
      this.#matches.set(item.asset.id, {
        bestMatch: item.bestMatch,
        selected: item.bestMatch,
        additionalMatches: [...item.additionalMatches],
        matchCount: item.matchCount,
        momentsComplete: false,
      });
    }
  }

  removeAssets(assetIds: Iterable<string>) {
    for (const id of assetIds) {
      this.#matches.delete(id);
    }
  }

  clear() {
    this.#matches.clear();
  }

  /** Points the card and viewer seek target at another distinct moment. */
  selectMoment(assetId: string, match: TranscriptionMatchDto) {
    const presentation = this.#matches.get(assetId);
    if (!presentation) {
      return;
    }
    const selectable = [presentation.bestMatch, ...presentation.additionalMatches];
    if (selectable.includes(match)) {
      this.#matches.set(assetId, { ...presentation, selected: match });
    }
  }

  /**
  Merges one page of the server's ranked moment list for a video, deduplicating
  by passage id against everything already known (the moment list includes the
  best match). Returns the newly added moments. A null cursor marks the list
  complete, which stops cards from offering further loading.
  */
  mergeMoments(assetId: string, response: TranscriptionMomentsResponseDto): TranscriptionMatchDto[] {
    const presentation = this.#matches.get(assetId);
    if (!presentation) {
      return [];
    }
    const known = new SvelteSet([
      presentation.bestMatch.passageId,
      ...presentation.additionalMatches.map((m) => m.passageId),
    ]);
    const merged: TranscriptionMatchDto[] = [];
    for (const moment of response.moments) {
      if (known.has(moment.passageId)) {
        continue;
      }

      known.add(moment.passageId);
      merged.push(moment);
    }
    if (merged.length > 0 || response.nextCursor === null) {
      this.#matches.set(assetId, {
        ...presentation,
        additionalMatches: [...presentation.additionalMatches, ...merged],
        momentsComplete: response.nextCursor === null,
      });
    }
    return merged;
  }
}

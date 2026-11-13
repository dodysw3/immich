import {
  DEFAULT_TRANSCRIPT_RANKING,
  buildTranscriptWindows,
  compareTranscriptMatches,
  deduplicateTranscriptMatches,
  normalizeTranscript,
  rankTranscriptWindow,
  transcriptContentRevision,
  type TokenSimilarity,
  type TranscriptMatch,
  type TranscriptRankingSettings,
} from 'src/utils/video-transcription-search.js';

const noSimilarity = () => 0;
const similar = () => 0.65;
const fuzzy = (a: string, b: string) => (a === 'boarding' && b === 'bord' ? 0.7 : 0);
/** Corpus similarity stub: strict_word_similarity-like pairs for the typo lane. */
const corpusSimilarity = (a: string, b: string) =>
  (a === 'boarding' && b === 'bording') || (a === 'announcement' && b === 'anouncement') ? 0.7 : 0;
const segment = (text: string, startMs: number, endMs = startMs + 1000) => ({ text, startMs, endMs });

describe('video transcription search', () => {
  it('normalizes accents, punctuation and original UTF-16 offsets', () => {
    const text = '😀 CAFÉ, cafe\u{301}!';
    const normalized = normalizeTranscript(text);
    expect(normalized.tokens.map((token) => token.text)).toEqual(['cafe', 'cafe']);
    expect(normalized.tokens.map(({ start, end }) => text.slice(start, end))).toEqual(['CAFÉ', 'cafe\u{301}']);
  });
  it('bounds windows but retains long segments and content revisions', () => {
    const segments = [segment('satu', 0), segment('dua', 1500), segment('lama', 10_000, 50_000)];
    const windows = buildTranscriptWindows(segments);
    expect(windows.map(({ id }) => id)).toEqual(['0:0', '0:1', '1:1', '2:2']);
    expect(transcriptContentRevision(segments)).not.toBe(
      transcriptContentRevision([segment('changed', 0), ...segments.slice(1)]),
    );
    expect(rankTranscriptWindow(windows[1], 'satu dua', noSimilarity)?.tier).toBe('exact-phrase');
    expect(rankTranscriptWindow(windows[1], 'dua', noSimilarity)?.startMs).toBe(1500);
  });
  it('orders exact phrase, unordered exact, fuzzy and partial without semantics', () => {
    const windows = ['boarding announcement', 'announcement boarding', 'bord ing announcement', 'boarding'].map(
      (text, i) => buildTranscriptWindows([segment(text, i * 1000)])[0],
    );
    const settings = {
      coverageWeight: 0.5,
      proximityWeight: 0.3,
      similarityWeight: 0.2,
      minimumCoverage: 0.5,
      fuzzyThreshold: 0.6,
      minimumFuzzyLength: 4,
    };
    const matches = windows
      .map((window) => rankTranscriptWindow(window, 'boarding announcement', fuzzy, settings)!)
      .sort(compareTranscriptMatches);
    expect(matches.map(({ tier }) => tier)).toEqual(['exact-phrase', 'exact-all', 'fuzzy', 'partial']);
    expect(
      rankTranscriptWindow(buildTranscriptWindows([segment('vehicle', 0)])[0], 'car', noSimilarity),
    ).toBeUndefined();
    expect(
      rankTranscriptWindow(buildTranscriptWindows([segment('carpet', 0)])[0], 'car', noSimilarity),
    ).toBeUndefined();
  });
  it('preserves multiplicity and collapses overlapping windows, not repeated moments', () => {
    const windows = buildTranscriptWindows([
      segment('halo halo', 0),
      segment('nama Budi', 1200),
      segment('halo halo', 2500),
    ]);
    expect(
      rankTranscriptWindow(buildTranscriptWindows([segment('halo', 0)])[0], 'halo halo', noSimilarity),
    ).toBeUndefined();
    const matches = windows.flatMap((window) => {
      const match = rankTranscriptWindow(window, 'halo halo', noSimilarity);
      return match ? [match] : [];
    });
    expect(deduplicateTranscriptMatches(matches)).toHaveLength(2);
    expect(
      rankTranscriptWindow(
        windows.find(({ id }) => id === '0:1')!,
        'halo nama',
        noSimilarity,
      )?.tier,
    ).toBe('exact-phrase');
  });
  it('matches Indonesian names and respects the spelling threshold and short-token policy', () => {
    const window = buildTranscriptWindows([segment('Budi pergi ke Jakarta', 0)])[0];
    expect(rankTranscriptWindow(window, 'budi pergi', noSimilarity)?.tier).toBe('exact-phrase');
    expect(rankTranscriptWindow(window, 'jakrta', similar)?.tier).toBe('fuzzy');
    const settings = {
      coverageWeight: 0.5,
      proximityWeight: 0.3,
      similarityWeight: 0.2,
      minimumCoverage: 1,
      fuzzyThreshold: 0.7,
      minimumFuzzyLength: 4,
    };
    expect(rankTranscriptWindow(window, 'jakrta', similar, settings)).toBeUndefined();
    expect(rankTranscriptWindow(window, 'ka', similar)).toBeUndefined();
  });
  it('uses Unicode full default case folding with original offsets', () => {
    const text = 'Straße İ I ı cafe\u{301}';
    const normalized = normalizeTranscript(text);
    expect(normalized.tokens.map((token) => token.text)).toEqual(['strasse', 'i', 'i', 'ı', 'cafe']);
    expect(text.slice(normalized.tokens[0].start, normalized.tokens[0].end)).toBe('Straße');
    expect(rankTranscriptWindow(buildTranscriptWindows([segment(text, 0)])[0], 'STRASSE', noSimilarity)?.tier).toBe(
      'exact-phrase',
    );
  });
  it('handles repeated tokens without factorial assignment and validates settings before early return', () => {
    const window = buildTranscriptWindows([
      segment(Array.from({ length: 80 }, () => 'alpha').join(' ') + ' bravo', 0),
    ])[0];
    expect(
      rankTranscriptWindow(window, Array.from({ length: 30 }, () => 'alpha').join(' ') + ' bravo', noSimilarity)?.tier,
    ).toBe('exact-phrase');
    expect(
      rankTranscriptWindow(window, Array.from({ length: 30 }, () => 'alpha').join(' ') + ' bravu', similar)?.tier,
    ).toBe('fuzzy');
    expect(() =>
      rankTranscriptWindow(window, '', noSimilarity, {
        coverageWeight: 0,
        proximityWeight: 0,
        similarityWeight: 0,
        minimumCoverage: 1,
        fuzzyThreshold: 0.6,
        minimumFuzzyLength: 4,
      }),
    ).toThrow();
  });

  describe('deterministic ranking corpus (id/en)', () => {
    const videos: Array<{ id: string; segments: Array<{ text: string; startMs: number; endMs: number }> }> = [
      {
        id: 'en-boarding-exact',
        segments: [
          segment('Ladies and gentlemen, the boarding announcement for flight GA 714', 0),
          segment('will begin shortly at gate five.', 4000),
        ],
      },
      {
        id: 'id-typo-only',
        segments: [
          segment('bording anouncement untuk penerbangan kali ini', 0),
          segment('mohon tetap tenang dan duduk.', 4000),
        ],
      },
      {
        id: 'id-repeated',
        segments: [
          segment('terima kasih telah menonton', 0),
          segment('terima kasih telah menonton video ini', 30_000),
          segment('sampai jumpa di video berikutnya', 60_000),
        ],
      },
      {
        id: 'id-proper-accent',
        segments: [segment('CAFÉ Jakarta, pagi! Perjalanan menuju Jabodetabek dimulai.', 0)],
      },
      {
        id: 'id-cross-boundary',
        segments: [segment('selamat', 0, 1000), segment('datang di LRT Jabodetabek', 1500, 5000)],
      },
      {
        id: 'en-short-tokens',
        segments: [segment('di ke ke pasar', 0)],
      },
    ];

    const allMatches = (query: string, similarity: TokenSimilarity, settings?: TranscriptRankingSettings) =>
      videos
        .flatMap((video) =>
          buildTranscriptWindows(video.segments)
            .map((window) => ({ video: video.id, match: rankTranscriptWindow(window, query, similarity, settings) }))
            .filter((entry): entry is { video: string; match: TranscriptMatch } => entry.match !== undefined),
        )
        .sort((a, b) => compareTranscriptMatches(a.match, b.match));

    it('ranks exact phrase above exact-all above fuzzy, regardless of repetitions', () => {
      const matches = allMatches('boarding announcement', noSimilarity, {
        ...DEFAULT_TRANSCRIPT_RANKING,
        minimumCoverage: 0.5,
      });
      // The fuzzy-only video may also hit, but it can never outrank the exact tier.
      expect(matches[0]!.video).toBe('en-boarding-exact');
      expect(matches[0]!.match.tier).toBe('exact-phrase');
      const fuzzyEntries = matches.filter((entry) => entry.match.tier === 'fuzzy');
      for (const entry of fuzzyEntries) {
        expect(compareTranscriptMatches(matches[0]!.match, entry.match)).toBeLessThan(0);
      }
      // Repeated "terima kasih telah menonton" moments: three hits, not a higher rank.
      const repeated = allMatches('telah menonton', noSimilarity).filter((entry) => entry.video === 'id-repeated');
      expect(repeated).toHaveLength(2);
      expect(new Set(repeated.map((entry) => entry.match.startMs))).toEqual(new Set([0, 30_000]));
    });

    it('treats accents, punctuation and case as equal while keeping original offsets', () => {
      const matches = allMatches('cafe jakarta', noSimilarity);
      expect(matches[0]!.video).toBe('id-proper-accent');
      const span = matches[0]!.match.spans[0]!;
      expect(matches[0]!.match.window.text.slice(span.start, span.end)).toBe('CAFÉ');
      expect(matches[0]!.match.window.startMs).toBe(0);
    });

    it('matches phrases crossing a segment boundary within the window', () => {
      const matches = allMatches('selamat datang', noSimilarity);
      expect(matches[0]!.video).toBe('id-cross-boundary');
      expect(matches[0]!.match.tier).toBe('exact-phrase');
      expect(matches[0]!.match.startMs).toBe(0);
    });

    it('keeps short tokens exact-only and substrings non-exact', () => {
      // "di"/"ke" are below the fuzzy minimum length: hits are exact only,
      // with zero spelling credit, across the whole corpus.
      const di = allMatches('dI', corpusSimilarity, { ...DEFAULT_TRANSCRIPT_RANKING, minimumCoverage: 0.5 });
      expect(di).toHaveLength(4);
      // Case-folded exact hits only — never a fuzzy tier for short tokens.
      expect(di.every((entry) => entry.match.tier === 'exact-phrase' || entry.match.tier === 'exact-all')).toBe(true);
      // "car" is not an exact word inside "pasar" or "carpet"-like text.
      const car = allMatches('car', noSimilarity);
      expect(car.every((entry) => entry.match.tier !== 'exact-phrase')).toBe(true);
      // "vehicle" gets no semantic credit anywhere.
      expect(allMatches('vehicle', noSimilarity, { ...DEFAULT_TRANSCRIPT_RANKING, minimumCoverage: 0.5 })).toHaveLength(
        0,
      );
    });

    it('applies raised fuzzy thresholds to subsequent searches without retranscription', () => {
      const permissive = allMatches('boarding announcement', corpusSimilarity, {
        ...DEFAULT_TRANSCRIPT_RANKING,
        minimumCoverage: 0.5,
      });
      expect(permissive.some((entry) => entry.video === 'id-typo-only')).toBe(true);

      const strict = allMatches('boarding announcement', corpusSimilarity, {
        ...DEFAULT_TRANSCRIPT_RANKING,
        minimumCoverage: 0.5,
        fuzzyThreshold: 0.95,
      });
      expect(strict.some((entry) => entry.video === 'id-typo-only')).toBe(false);
      expect(strict[0]!.video).toBe('en-boarding-exact');
    });
  });
});

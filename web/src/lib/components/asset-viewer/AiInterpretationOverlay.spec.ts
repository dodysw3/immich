import { AssetTypeEnum, getAssetMetadataByKey } from '@immich/sdk';
import '@testing-library/jest-dom';
import { fireEvent, screen, waitFor } from '@testing-library/svelte';
import { renderWithTooltips } from '$tests/helpers';
import { assetFactory } from '@test-data/factories/asset-factory';
import AiInterpretationOverlay from './AiInterpretationOverlay.svelte';

vi.mock('@immich/sdk', async (originalImport) => {
  const sdk = await originalImport<typeof import('@immich/sdk')>();
  return { ...sdk, getAssetMetadataByKey: vi.fn() };
});

const metadata = (runs: Record<string, unknown>) => ({
  key: 'ai-interpretation-v1',
  updatedAt: '2026-09-11T00:00:00.000Z',
  value: { schemaVersion: 1, runs },
});
const SESSION_STORAGE_KEY = 'immich-ai-interpretation-overlay-enabled';

describe('AiInterpretationOverlay', () => {
  beforeEach(() => {
    sessionStorage.removeItem(SESSION_STORAGE_KEY);
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  it('shows a toggle for present metadata and renders the latest completed result', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(
      metadata({
        newer: {
          requestedAt: '2026-09-11T01:00:00.000Z',
          status: 'completed',
          result: {
            title: 'Latest title',
            interpretation: 'Latest interpretation',
            archive_summary: 'Latest archive summary',
            notable_details: [
              { detail: 'Medium detail', significance: 'Medium significance', confidence: 'medium' },
              { detail: 'High detail', significance: 'High significance', confidence: 'high' },
              { detail: 'Low detail', significance: 'Low significance', confidence: 'low' },
            ],
          },
        },
        older: {
          requestedAt: '2026-09-11T00:00:00.000Z',
          status: 'completed',
          result: { title: 'Older title', archive_summary: 'Older archive summary' },
        },
      }),
    );

    renderWithTooltips(AiInterpretationOverlay, {
      asset: assetFactory.build({ type: AssetTypeEnum.Image }),
      buttonBottom: 24,
    });

    const button = await screen.findByLabelText('ai_interpretation');
    expect(button).toHaveAttribute('aria-pressed', 'false');

    await fireEvent.click(button);

    expect(await screen.findByTestId('ai-interpretation-title')).toHaveTextContent('Latest title');
    expect(screen.getByTestId('ai-interpretation-title')).not.toHaveTextContent('Older title');
    expect(screen.getByTestId('ai-interpretation-summary')).toHaveTextContent(
      '[I] Latest interpretation // [S] Latest archive summary',
    );
    expect(screen.getByTestId('ai-interpretation-overlay')).toHaveClass('fixed');
    expect(screen.getByTestId('ai-interpretation-title')).toHaveClass('text-left', 'font-bold', 'text-white');
    expect(screen.getByTestId('ai-interpretation-summary')).toHaveClass('text-left', 'text-sm/snug', 'wrap-break-word');
    expect(screen.getByTestId('ai-interpretation-summary')).not.toHaveClass('font-bold');
    expect(screen.getByTestId('ai-interpretation-bottom')).toHaveStyle({
      'inset-inline-end': '5rem',
    });
    expect(screen.getByTestId('ai-interpretation-summary')).toHaveStyle({
      'text-shadow': '0 2px 4px rgb(0 0 0 / 0.95), 0 0 8px rgb(0 0 0 / 0.8)',
    });

    expect(screen.getAllByTestId('ai-interpretation-notable-detail').map((tag) => tag.textContent?.trim())).toEqual([
      'High detail',
      'Medium detail',
      'Low detail',
    ]);
    expect(screen.getByText('High detail')).toHaveClass('rounded-full', 'bg-green-600/90', 'text-white');
    expect(screen.getByText('Medium detail')).toHaveClass('rounded-full', 'bg-amber-500/90', 'text-black');
    expect(screen.getByText('Low detail')).toHaveClass('rounded-full', 'bg-red-600/90', 'text-white');
    expect(screen.getByText('High detail')).toHaveAttribute('data-tooltip-trigger');
    await fireEvent.pointerEnter(screen.getByText('High detail'));
    expect(await screen.findByText('High significance')).toBeInTheDocument();

    await fireEvent.click(button);
    expect(screen.queryByTestId('ai-interpretation-overlay')).toBeNull();
    expect(button).toHaveAttribute('aria-pressed', 'false');
    expect(sessionStorage.getItem(SESSION_STORAGE_KEY)).toBe('false');
  });

  it('clears the prior metadata and overlay when the asset changes', async () => {
    type Metadata = Awaited<ReturnType<typeof getAssetMetadataByKey>>;
    let resolveSecond!: (value: Metadata) => void;
    vi.mocked(getAssetMetadataByKey).mockImplementation(({ id }) => {
      if (id === 'asset-a') {
        return Promise.resolve(
          metadata({
            run: {
              requestedAt: '2026-09-11T00:00:00.000Z',
              status: 'completed',
              result: { title: 'First title' },
            },
          }),
        );
      }

      return new Promise<Metadata>((resolve) => {
        resolveSecond = resolve;
      });
    });

    const { rerender } = renderWithTooltips(AiInterpretationOverlay, {
      asset: assetFactory.build({ id: 'asset-a', type: AssetTypeEnum.Image }),
      buttonBottom: 24,
    });

    const button = await screen.findByLabelText('ai_interpretation');
    await fireEvent.click(button);
    expect(await screen.findByTestId('ai-interpretation-title')).toHaveTextContent('First title');

    await rerender({
      component: AiInterpretationOverlay,
      componentProps: {
        asset: assetFactory.build({ id: 'asset-b', type: AssetTypeEnum.Image }),
        buttonBottom: 24,
      },
    } as never);

    expect(screen.queryByLabelText('ai_interpretation')).toBeNull();
    expect(screen.queryByTestId('ai-interpretation-overlay')).toBeNull();

    resolveSecond(
      metadata({
        run: {
          requestedAt: '2026-09-11T02:00:00.000Z',
          status: 'completed',
          result: { archive_summary: 'Second summary' },
        },
      }),
    );
    await waitFor(() => {
      expect(screen.getByLabelText('ai_interpretation')).toHaveAttribute('aria-pressed', 'true');
      expect(screen.getByTestId('ai-interpretation-summary')).toHaveTextContent('[S] Second summary');
    });
  });

  it('keeps the toggle but omits missing or non-string result fields', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(
      metadata({
        run: {
          requestedAt: '2026-09-11T00:00:00.000Z',
          status: 'completed',
          result: { title: 123, archive_summary: '' },
        },
      }),
    );

    renderWithTooltips(AiInterpretationOverlay, {
      asset: assetFactory.build({ type: AssetTypeEnum.Image }),
      buttonBottom: 24,
    });

    const button = await screen.findByLabelText('ai_interpretation');
    await fireEvent.click(button);
    await waitFor(() => expect(screen.queryByTestId('ai-interpretation-overlay')).toBeNull());
  });

  it('restores the enabled state for a new viewer instance in the same session', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(
      metadata({
        run: {
          requestedAt: '2026-09-11T00:00:00.000Z',
          status: 'completed',
          result: { title: 'Persisted title' },
        },
      }),
    );

    const firstViewer = renderWithTooltips(AiInterpretationOverlay, {
      asset: assetFactory.build({ type: AssetTypeEnum.Image }),
      buttonBottom: 24,
    });
    const firstButton = await screen.findByLabelText('ai_interpretation');
    await fireEvent.click(firstButton);
    expect(sessionStorage.getItem(SESSION_STORAGE_KEY)).toBe('true');
    firstViewer.unmount();

    renderWithTooltips(AiInterpretationOverlay, {
      asset: assetFactory.build({ type: AssetTypeEnum.Image }),
      buttonBottom: 24,
    });
    const secondButton = await screen.findByLabelText('ai_interpretation');
    expect(secondButton).toHaveAttribute('aria-pressed', 'true');
    expect(await screen.findByTestId('ai-interpretation-title')).toHaveTextContent('Persisted title');
  });

  it('keeps the in-memory toggle usable when session storage is unavailable', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(metadata({}));
    const setItem = vi.spyOn(Storage.prototype, 'setItem').mockImplementation(() => {
      throw new Error('session storage unavailable');
    });

    renderWithTooltips(AiInterpretationOverlay, {
      asset: assetFactory.build({ type: AssetTypeEnum.Image }),
      buttonBottom: 24,
    });
    const button = await screen.findByLabelText('ai_interpretation');

    await fireEvent.click(button);
    expect(button).toHaveAttribute('aria-pressed', 'true');
    setItem.mockRestore();
  });
});

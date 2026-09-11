import { getAssetMetadataByKey } from '@immich/sdk';
import '@testing-library/jest-dom';
import { render, screen, waitFor } from '@testing-library/svelte';
import { assetFactory } from '@test-data/factories/asset-factory';
import DetailPanelAiInterpretation from './DetailPanelAiInterpretation.svelte';

vi.mock('@immich/sdk', async (originalImport) => {
  const sdk = await originalImport<typeof import('@immich/sdk')>();
  return { ...sdk, getAssetMetadataByKey: vi.fn() };
});

describe('DetailPanelAiInterpretation', () => {
  afterEach(() => {
    vi.clearAllMocks();
  });

  it('renders present metadata as escaped pretty-printed JSON', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue({
      key: 'ai-interpretation-v1',
      updatedAt: '2026-09-11T00:00:00.000Z',
      value: { schemaVersion: 1, runs: {}, note: '<script>alert(1)</script>' },
    });

    render(DetailPanelAiInterpretation, { asset: assetFactory.build({ id: 'asset-a' }) });

    const panel = await screen.findByTestId('ai-interpretation');
    expect(panel).toHaveTextContent('schemaVersion');
    expect(panel).toHaveTextContent('<script>alert(1)</script>');
    expect(panel.querySelector('script')).toBeNull();
  });

  it('hides when the metadata is absent or cannot be fetched', async () => {
    vi.mocked(getAssetMetadataByKey).mockRejectedValue(new Error('not found'));

    render(DetailPanelAiInterpretation, { asset: assetFactory.build({ id: 'asset-a' }) });

    await waitFor(() => expect(getAssetMetadataByKey).toHaveBeenCalled());
    expect(screen.queryByTestId('ai-interpretation')).toBeNull();
  });

  it('clears the previous asset while the next metadata request is pending', async () => {
    type Metadata = Awaited<ReturnType<typeof getAssetMetadataByKey>>;
    let resolveFirst!: (metadata: Metadata) => void;
    const first = new Promise<Metadata>((resolve) => {
      resolveFirst = resolve;
    });
    const second = new Promise<Metadata>(() => {});
    vi.mocked(getAssetMetadataByKey).mockImplementation(({ id }) => (id === 'asset-a' ? first : second));

    const { rerender } = render(DetailPanelAiInterpretation, {
      asset: assetFactory.build({ id: 'asset-a' }),
    });
    resolveFirst({
      key: 'ai-interpretation-v1',
      updatedAt: '2026-09-11T00:00:00.000Z',
      value: { schemaVersion: 1, runs: {} },
    });
    await screen.findByTestId('ai-interpretation');

    await rerender({ asset: assetFactory.build({ id: 'asset-b' }) });

    expect(screen.queryByTestId('ai-interpretation')).toBeNull();
  });

  it('keeps long JSON inside the scrollable panel', async () => {
    const longText = 'detail '.repeat(1000);
    vi.mocked(getAssetMetadataByKey).mockResolvedValue({
      key: 'ai-interpretation-v1',
      updatedAt: '2026-09-11T00:00:00.000Z',
      value: { schemaVersion: 1, runs: {}, longText },
    });

    render(DetailPanelAiInterpretation, { asset: assetFactory.build({ id: 'asset-a' }) });

    const panel = await screen.findByTestId('ai-interpretation');
    expect(panel).toHaveTextContent(longText);
    expect(panel.querySelector('pre')).toHaveClass('max-h-96', 'overflow-auto');
  });
});

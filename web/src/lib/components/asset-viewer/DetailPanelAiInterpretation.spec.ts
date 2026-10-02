import { getAssetMetadataByKey } from '@immich/sdk';
import '@testing-library/jest-dom';
import { render, screen, waitFor } from '@testing-library/svelte';
import userEvent from '@testing-library/user-event';
import { init, register, waitLocale } from 'svelte-i18n';
import { assetFactory } from '@test-data/factories/asset-factory';
import DetailPanelAiInterpretation from './DetailPanelAiInterpretation.svelte';

vi.mock('@immich/sdk', async (originalImport) => {
  const sdk = await originalImport<typeof import('@immich/sdk')>();
  return { ...sdk, getAssetMetadataByKey: vi.fn() };
});

beforeAll(async () => {
  await init({ fallbackLocale: 'en-US' });
  register('en-US', () => import('$i18n/en.json'));
  await waitLocale('en-US');
});

const runKey = 'a6bb4076501b5e5f7cf7b69d0631f6dfc50ebdfb07c9c708e497ed58b10f44d2';

const completedRun = {
  model: 'unsloth/Muse-Glimmer-30B-GGUF',
  quant: 'UD-Q3_K_XL',
  promptVersion: 'image-interpretation-1.0.0',
  status: 'completed',
  trigger: 'upload',
  requestedAt: '2026-09-11T10:00:00.000Z',
  startedAt: '2026-09-11T10:00:01.000Z',
  finishedAt: '2026-09-11T10:02:01.000Z',
  input: { source: 'preview', width: 1600, height: 1200, mimeType: 'image/jpeg' },
  metrics: { durationMs: 120_700, promptTokens: 2540, completionTokens: 1486 },
  result: {
    title: 'Indoor family gathering',
    archive_summary: 'A candid indoor photograph of a group of adults and children.',
    interpretation: 'The image appears to capture a relaxed domestic moment.',
    literal_description: 'An indoor living room scene with several people.',
    visual_analysis: 'The composition is centered on the sofa group.',
    context_and_significance: 'Likely a family or social visit.',
    uncertainties: ['The identities of the people are unknown.', 'The exact location is not visible.'],
    alternative_interpretations: ['The scene could alternatively be a community center.'],
    identifications: [],
    notable_details: [
      {
        detail: 'Woman wearing a patterned hijab seated on sofa',
        significance: 'Indicates cultural dress and suggests a domestic setting',
        confidence: 'high',
      },
      {
        detail: 'Smartphone held in foreground',
        confidence: 'low',
      },
    ],
    search_keywords: ['family gathering', 'living room'],
  },
};

const documentWith = (runs: Record<string, unknown>) => ({
  key: 'ai-interpretation-v1',
  updatedAt: '2026-09-11T00:00:00.000Z',
  value: { schemaVersion: 1, runs },
});

const renderPanel = () => render(DetailPanelAiInterpretation, { asset: assetFactory.build({ id: 'asset-a' }) });

describe('DetailPanelAiInterpretation', () => {
  afterEach(() => {
    vi.clearAllMocks();
  });

  it('renders a completed run as a readable inspector without raw JSON by default', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(documentWith({ [runKey]: completedRun }));

    renderPanel();

    const panel = await screen.findByTestId('ai-interpretation');
    expect(screen.getByTestId('ai-interpretation-status')).toHaveTextContent('Completed');
    expect(screen.getByTestId('ai-interpretation-title')).toHaveTextContent('Indoor family gathering');
    expect(panel).toHaveTextContent('A candid indoor photograph of a group of adults and children.');
    expect(screen.getByTestId('ai-interpretation-summary')).toHaveTextContent(
      'The image appears to capture a relaxed domestic moment.',
    );

    const details = screen.getByTestId('ai-interpretation-notable-details');
    expect(details).toHaveTextContent('Woman wearing a patterned hijab seated on sofa');
    expect(details).toHaveTextContent('HIGH');
    expect(details).toHaveTextContent('LOW');
    expect(details).toHaveTextContent('Indicates cultural dress and suggests a domestic setting');

    expect(screen.getByText('family gathering · living room')).toBeInTheDocument();
    expect(screen.getByTestId('ai-interpretation-inference')).toHaveTextContent('Muse-Glimmer-30B');
    expect(screen.getByTestId('ai-interpretation-inference')).toHaveTextContent('UD-Q3_K_XL');

    expect(screen.getByRole('button', { name: 'Uncertainties (2)' })).toHaveAttribute('aria-expanded', 'false');
    expect(screen.queryByText('The identities of the people are unknown.')).toBeNull();
    expect(panel).not.toHaveTextContent('An indoor living room scene with several people.');
    expect(screen.queryByRole('button', { name: 'Raw JSON' })).not.toBeNull();
    expect(panel).not.toHaveTextContent('schemaVersion');
  });

  it('keeps legacy result fields available through collapsed sections', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(documentWith({ [runKey]: completedRun }));
    const user = userEvent.setup();

    renderPanel();

    await screen.findByTestId('ai-interpretation');
    expect(screen.queryByText('Identifications')).toBeNull();

    await user.click(screen.getByRole('button', { name: 'Uncertainties (2)' }));
    expect(screen.getByText('The exact location is not visible.')).toBeInTheDocument();

    await user.click(screen.getByRole('button', { name: 'Visual analysis' }));
    expect(screen.getByText('The composition is centered on the sofa group.')).toBeInTheDocument();

    await user.click(screen.getByRole('button', { name: 'Context and significance' }));
    expect(screen.getByText('Likely a family or social visit.')).toBeInTheDocument();

    await user.click(screen.getByRole('button', { name: 'Literal description' }));
    expect(screen.getByText('An indoor living room scene with several people.')).toBeInTheDocument();
  });

  it('exposes technical details and raw JSON only after expanding them', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(documentWith({ [runKey]: completedRun }));
    const user = userEvent.setup();

    renderPanel();

    const panel = await screen.findByTestId('ai-interpretation');
    expect(panel).not.toHaveTextContent(runKey);
    expect(panel).not.toHaveTextContent('unsloth/Muse-Glimmer-30B-GGUF');

    await user.click(screen.getByRole('button', { name: 'Technical details' }));
    expect(screen.getByText('unsloth/Muse-Glimmer-30B-GGUF')).toBeInTheDocument();
    expect(screen.getByText('image-interpretation-1.0.0')).toBeInTheDocument();
    expect(screen.getByText(runKey)).toBeInTheDocument();

    await user.click(screen.getByRole('button', { name: 'Raw JSON' }));
    const pre = panel.querySelector('pre');
    expect(pre).toHaveClass('max-h-96', 'overflow-auto');
    expect(pre).toHaveTextContent('schemaVersion');
    expect(pre).toHaveTextContent('promptVersion');
  });

  it('renders raw JSON as escaped text without executing markup', async () => {
    const xssRun = {
      ...completedRun,
      result: { ...completedRun.result, title: '<script>alert(1)</script>' },
    };
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(documentWith({ [runKey]: xssRun }));
    const user = userEvent.setup();

    renderPanel();

    await screen.findByTestId('ai-interpretation');
    await user.click(screen.getByRole('button', { name: 'Raw JSON' }));

    expect(screen.getByTestId('ai-interpretation')).toHaveTextContent('<script>alert(1)</script>');
    expect(screen.getByTestId('ai-interpretation').querySelector('script')).toBeNull();
  });

  it('shows a subtle failed status with no result content', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(
      documentWith({
        [runKey]: {
          model: 'unsloth/Muse-Glimmer-30B-GGUF',
          quant: 'UD-Q3_K_XL',
          promptVersion: 'image-interpretation-1.1.0',
          status: 'failed',
          trigger: 'upload',
          requestedAt: '2026-09-11T10:00:00.000Z',
          attempts: 3,
          nextAttemptAt: '2026-09-11T11:00:00.000Z',
          error: { code: 'upstream_error', message: 'Model endpoint unreachable' },
        },
      }),
    );

    renderPanel();

    const panel = await screen.findByTestId('ai-interpretation');
    expect(screen.getByTestId('ai-interpretation-status')).toHaveTextContent('Failed');
    expect(screen.queryByTestId('ai-interpretation-title')).toBeNull();
    expect(panel).toHaveTextContent('Model endpoint unreachable');
  });

  it('hides entirely when there are no runs', async () => {
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(documentWith({}));

    renderPanel();

    await waitFor(() => expect(getAssetMetadataByKey).toHaveBeenCalled());
    expect(screen.queryByTestId('ai-interpretation')).toBeNull();
  });

  it('prefers the latest completed run when several exist', async () => {
    const olderKey = 'b'.repeat(64);
    vi.mocked(getAssetMetadataByKey).mockResolvedValue(
      documentWith({
        [olderKey]: {
          ...completedRun,
          status: 'completed',
          requestedAt: '2026-09-10T10:00:00.000Z',
          finishedAt: '2026-09-10T10:02:00.000Z',
          result: { ...completedRun.result, title: 'Older interpretation' },
        },
        [runKey]: { ...completedRun, status: 'completed' },
      }),
    );

    renderPanel();

    await screen.findByTestId('ai-interpretation');
    expect(screen.getByTestId('ai-interpretation-title')).toHaveTextContent('Indoor family gathering');
    expect(screen.queryByText('Older interpretation')).toBeNull();
  });

  it('hides when the metadata is absent or cannot be fetched', async () => {
    vi.mocked(getAssetMetadataByKey).mockRejectedValue(new Error('not found'));

    renderPanel();

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

    const { rerender } = renderPanel();
    resolveFirst(documentWith({ [runKey]: completedRun }));
    await screen.findByTestId('ai-interpretation');

    await rerender({ asset: assetFactory.build({ id: 'asset-b' }) });

    expect(screen.queryByTestId('ai-interpretation')).toBeNull();
  });
});

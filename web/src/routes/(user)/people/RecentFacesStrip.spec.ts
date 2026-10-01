import { getRecentlyMatched } from '@immich/sdk';
import '@testing-library/jest-dom';
import { render, screen, waitFor } from '@testing-library/svelte';
import { vi, describe, beforeEach, it, expect } from 'vitest';
import RecentFacesStrip from './RecentFacesStrip.svelte';

vi.mock('@immich/sdk', () => ({
  getRecentlyMatched: vi.fn(),
  AssetMediaSize: { Thumbnail: 'thumbnail' },
}));

vi.mock('$lib/utils', () => ({
  getAssetMediaUrl: vi.fn().mockReturnValue('/api/assets/thumbnail'),
}));

vi.mock('$lib/utils/navigation', () => ({
  navigate: vi.fn(),
}));

vi.mock('$lib/route', () => ({
  Route: {
    viewPerson: ({ id }: { id: string }) => `/people/${id}`,
  },
}));

vi.mock('$lib/components/assets/thumbnail/ImageThumbnail.svelte', async () => {
  return await import('./RecentFacesStrip.spec-mock.svelte');
});

const mockedGetRecentlyMatched = vi.mocked(getRecentlyMatched);

describe('RecentFacesStrip component', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('renders nothing when the feed is empty', async () => {
    mockedGetRecentlyMatched.mockResolvedValue({ items: [], total: 0 });
    render(RecentFacesStrip);
    await waitFor(() => expect(mockedGetRecentlyMatched).toHaveBeenCalledWith({ limit: 50 }));
    await waitFor(() => expect(screen.queryByText('Recently recognized')).not.toBeInTheDocument());
    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });

  it('renders nothing when the feed request fails', async () => {
    mockedGetRecentlyMatched.mockRejectedValue(new Error('network down'));
    render(RecentFacesStrip);
    await waitFor(() => expect(mockedGetRecentlyMatched).toHaveBeenCalled());
    expect(screen.queryByText('Recently recognized')).not.toBeInTheDocument();
    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });

  it('renders a card per pair newest first, with em-dash for unnamed people', async () => {
    mockedGetRecentlyMatched.mockResolvedValue({
      total: 2,
      items: [
        { assetId: 'asset-1', personId: 'person-1', personName: 'Alice', recognizedAt: '2026-10-01T10:00:00.000Z' },
        { assetId: 'asset-2', personId: 'person-2', personName: '', recognizedAt: '2026-10-01T09:00:00.000Z' },
      ],
    });
    render(RecentFacesStrip);
    await waitFor(() => expect(screen.getByText('Recently recognized')).toBeInTheDocument());
    expect(screen.getByText('Alice')).toBeInTheDocument();
    expect(screen.getByText('—')).toBeInTheDocument();
    expect(screen.getByText('View all →')).toBeInTheDocument();
    const personLinks = screen.getAllByRole('link');
    expect(personLinks.map((link) => link.getAttribute('href'))).toEqual([
      '/people/recently-matched',
      '/people/person-1',
      '/people/person-2',
    ]);
  });
});

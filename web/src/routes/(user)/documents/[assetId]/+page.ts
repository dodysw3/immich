import { authenticate } from '$lib/utils/auth';
import { error } from '@sveltejs/kit';
import type { PageLoad } from './$types';

export const load = (async ({ url, fetch, params }) => {
  await authenticate(url);

  const [documentResponse, pagesResponse] = await Promise.all([
    fetch(`/api/documents/${params.assetId}`),
    fetch(`/api/documents/${params.assetId}/pages`),
  ]);

  if (!documentResponse.ok) {
    throw error(documentResponse.status, 'Document not found');
  }

  const document = await documentResponse.json();
  const pages = pagesResponse.ok ? await pagesResponse.json() : [];

  return {
    document,
    pages,
    meta: {
      title: document.title || document.originalFileName || 'Document',
    },
  };
}) satisfies PageLoad;

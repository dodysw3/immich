<script lang="ts">
  import Image from '$lib/components/Image.svelte';
  import type { AdaptiveImageLoader, ImageQuality } from '$lib/utils/adaptive-image-loader.svelte';

  type Props = {
    adaptiveImageLoader: AdaptiveImageLoader;
    quality: ImageQuality;
    src: string | undefined;
    alt?: string;
    role?: string;
    ref?: HTMLImageElement;
    width: string;
    height: string;
    transform?: string;
  };

  let {
    adaptiveImageLoader,
    quality,
    src,
    alt = '',
    role,
    ref = $bindable(),
    width,
    height,
    transform,
  }: Props = $props();
</script>

{#key adaptiveImageLoader}
  <div
    class="absolute top-0 origin-top-left"
    style:width
    style:height
    style:transform
    style:will-change={transform ? 'transform' : undefined}
  >
    <Image
      {src}
      onStart={() => adaptiveImageLoader.onStart(quality)}
      onLoad={() => adaptiveImageLoader.onLoad(quality)}
      onError={() => adaptiveImageLoader.onError(quality)}
      bind:ref
      class="h-full w-full bg-transparent pointer-events-auto"
      {alt}
      {role}
      draggable={false}
      data-testid={quality}
    />
  </div>
{/key}

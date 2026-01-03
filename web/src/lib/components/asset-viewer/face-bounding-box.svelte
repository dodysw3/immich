<script lang="ts">
  import { goto } from '$app/navigation';
  import { page } from '$app/stores';
  import { AppRoute, QueryParameter } from '$lib/constants';
  import type { FaceBoundingBox } from '$lib/utils/people-utils';

  type Props = {
    faceBox: FaceBoundingBox;
    assetId: string;
  };

  let { faceBox, assetId }: Props = $props();
  let isHovered = $state(false);

  const handleClick = () => {
    if (faceBox.personId) {
      const previousRoute = $page.url.pathname;
      goto(`${AppRoute.PEOPLE}/${faceBox.personId}?at=${assetId}&${QueryParameter.PREVIOUS_ROUTE}=${previousRoute}`);
    }
  };
</script>

<div
  class="absolute group"
  class:pointer-events-auto={faceBox.personId}
  class:pointer-events-none={!faceBox.personId}
  class:cursor-pointer={faceBox.personId}
  style="top: {faceBox.top}px; left: {faceBox.left}px; width: {faceBox.width}px; height: {faceBox.height}px;"
  role={faceBox.personId ? 'button' : undefined}
  tabindex={faceBox.personId ? 0 : undefined}
  onclick={handleClick}
  onkeydown={(e) => e.key === 'Enter' && handleClick()}
  onmouseenter={() => (isHovered = true)}
  onmouseleave={() => (isHovered = false)}
>
  <!-- Face bounding box -->
  <div
    class="absolute inset-0 rounded-lg transition-all"
    class:border={!isHovered}
    class:border-green-500={!isHovered}
    class:border-3={isHovered}
    class:border-white={isHovered}
  ></div>

  <!-- Person name label (if available) -->
  {#if faceBox.personName}
    <div
      class="absolute left-0 right-0 text-center text-white text-xs bg-black/75 px-1 py-0.5 rounded-b break-all max-w-full pointer-events-none"
      style="top: {faceBox.height}px;"
    >
      {faceBox.personName}
    </div>
  {/if}
</div>

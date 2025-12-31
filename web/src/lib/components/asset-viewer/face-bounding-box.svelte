<script lang="ts">
  import type { FaceBoundingBox } from '$lib/utils/people-utils';

  type Props = {
    faceBox: FaceBoundingBox;
  };

  let { faceBox }: Props = $props();
</script>

<div
  class="absolute pointer-events-none group"
  style="top: {faceBox.top}px; left: {faceBox.left}px; width: {faceBox.width}px; height: {faceBox.height}px;"
>
  <!-- Face bounding box -->
  <div
    class="absolute inset-0 border border-green-500 rounded-lg transition-all group-hover:border-green-600 group-hover:border-2"
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

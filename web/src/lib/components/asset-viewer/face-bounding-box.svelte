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
    class="absolute inset-0 border-2 border-green-500 bg-green-500/10 rounded-lg transition-all group-hover:bg-green-500/30 group-hover:border-green-600 group-hover:border-[3px]"
  ></div>

  <!-- Person name label (if available) -->
  {#if faceBox.personName}
    <div
      class="absolute left-0 right-0 text-center text-white text-sm bg-black/75 px-2 py-1 rounded-b truncate max-w-full pointer-events-none"
      style="top: {faceBox.height}px;"
    >
      {faceBox.personName}
    </div>
  {/if}
</div>

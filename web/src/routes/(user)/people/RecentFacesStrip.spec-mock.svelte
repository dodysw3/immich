<script lang="ts">
  interface Props {
    altText?: string;
  }

  let { altText }: Props = $props();
</script>

<div data-testid="image-thumbnail-mock" data-alt={altText}></div>

<script module>
  import { defineMeta } from '@storybook/addon-svelte-csf';
  import Button from './Button.svelte';

  const { Story } = defineMeta({
    title: 'UI/Button',
    component: Button,
    tags: ['autodocs']
  });
</script>

<Story name="Primary">
  <Button>Click me</Button>
</Story>

<Story name="Variants">
  {#snippet template()}
  <Button variant="primary">Primary</Button>
  <Button variant="secondary">Secondary</Button>
  <Button variant="ghost">Ghost</Button>
  <Button variant="destructive">Destructive</Button>
  {/snippet}
</Story>

<Story name="Sizes">
  {#snippet template()}
  <Button size="sm">Small</Button>
  <Button size="md">Medium</Button>
  <Button size="lg">Large</Button>
</Story>

<Story name="Loading">
  <Button loading>Saving...</Button>
</Story>

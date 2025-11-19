<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Stack from './Stack.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Stack',
		component: Stack,
		tags: ['autodocs'],
		args: {
			gap: '1rem',
			align: 'stretch',
			justify: 'flex-start'
		},
		argTypes: {
			gap: { control: { type: 'text' } },
			align: { control: { type: 'text' } },
			justify: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Default Stack">
	<Stack>
		{#snippet children()}
			<div class="demo-box">One</div>
			<div class="demo-box">Two</div>
			<div class="demo-box">Three</div>
		{/snippet}
	</Stack>
</Story>

<Story
	name="Centered Stack"
	args={{ gap: '2rem', align: 'center', justify: 'center', maxWidth: '22rem' }}
>
	<div class="demo-box">Item A</div>
	<div class="demo-box">Item B</div>
	<div class="demo-box">Item C</div>
</Story>

<style>
	.demo-box {
		background: color-mix(in srgb, var(--storybook-background) 60%, #000);
		border-radius: 0.5rem;
		padding: 0.75rem 1rem;
		font-weight: 500;
	}
</style>

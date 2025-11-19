<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Reel from './Reel.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Reel',
		component: Reel,
		tags: ['autodocs'],
		args: {
			gap: '1rem',
			itemWidth: '14rem',
			snap: true
		},
		argTypes: {
			gap: { control: { type: 'text' } },
			itemWidth: { control: { type: 'text' } },
			snap: { control: { type: 'boolean' } }
		}
	});
</script>

<Story name="Cards">
	{#each ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta'] as label (label)}
		<div class="card">
			<h4>{label}</h4>
			<p>Swipe horizontally to browse.</p>
		</div>
	{/each}
</Story>

<Story name="Wide items" args={{ itemWidth: '20rem' }}>
	{#each ['One', 'Two', 'Three'] as label (label)}
		<div class="panel">
			<h4>{label}</h4>
			<p>Use larger widths for feature blocks.</p>
		</div>
	{/each}
</Story>

<style>
	.card,
	.panel {
		display: grid;
		gap: 0.5rem;
		padding: 1rem;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background) 55%, #000);
	}

	.panel {
		background: color-mix(in srgb, var(--storybook-background) 65%, #000);
	}
</style>

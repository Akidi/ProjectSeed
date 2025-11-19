<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Grid from './Grid.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Grid',
		component: Grid,
		tags: ['autodocs'],
		args: {
			gap: '1rem',
			minItemWidth: '16rem'
		},
		argTypes: {
			gap: { control: { type: 'text' } },
			minItemWidth: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Auto-fit tiles">
	{#each ['One', 'Two', 'Three', 'Four', 'Five', 'Six'] as label (label)}
		<div class="tile">{label}</div>
	{/each}
</Story>

<Story name="Dense grid" args={{ minItemWidth: '12rem', gap: '0.75rem' }}>
	{#each ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta'] as label (label)}
		<div class="tile muted">{label}</div>
	{/each}
</Story>

<style>
	.tile {
		display: grid;
		place-items: center;
		padding: 1rem;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background) 60%, #000);
		font-weight: 700;
	}

	.tile.muted {
		background: color-mix(in srgb, var(--storybook-background) 70%, #000);
	}
</style>

<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Cluster from './Cluster.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Cluster',
		component: Cluster,
		tags: ['autodocs'],
		args: {
			gap: '0.75rem',
			align: 'center',
			justify: 'flex-start'
		},
		argTypes: {
			gap: { control: { type: 'text' } },
			align: { control: { type: 'text' } },
			justify: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Default">
	<div class="chip">One</div>
	<div class="chip">Two</div>
	<div class="chip">Three</div>
	<div class="chip">Four</div>
	<div class="chip">Five</div>
</Story>

<Story name="Centered" args={{ justify: 'center', gap: '1rem' }}>
	<div class="pill">Alpha</div>
	<div class="pill">Beta</div>
	<div class="pill">Gamma</div>
</Story>

<style>
	.chip {
		display: inline-flex;
		align-items: center;
		padding: 0.25rem 0.75rem;
		border-radius: 9999px;
		background: color-mix(in srgb, var(--storybook-background) 70%, #000);
		font-weight: 600;
	}

	.pill {
		display: inline-flex;
		align-items: center;
		padding: 0.4rem 1rem;
		border-radius: 9999px;
		background: color-mix(in srgb, var(--storybook-background) 60%, #000);
		font-weight: 600;
		letter-spacing: 0.01em;
		text-transform: uppercase;
	}
</style>

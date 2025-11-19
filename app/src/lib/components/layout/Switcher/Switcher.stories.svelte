<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Switcher from './Switcher.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Switcher',
		component: Switcher,
		tags: ['autodocs'],
		args: {
			gap: '1rem',
			minItemWidth: '18rem'
		},
		argTypes: {
			gap: { control: { type: 'text' } },
			minItemWidth: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Cards">
	<div class="card">
		<h4>Alpha</h4>
		<p>Responsive cards collapse when space runs out.</p>
	</div>
	<div class="card">
		<h4>Beta</h4>
		<p>Responsive cards collapse when space runs out.</p>
	</div>
	<div class="card">
		<h4>Gamma</h4>
		<p>Responsive cards collapse when space runs out.</p>
	</div>
	<div class="card">
		<h4>Delta</h4>
		<p>Responsive cards collapse when space runs out.</p>
	</div>
	<div class="card">
		<h4>Epsilon</h4>
		<p>Responsive cards collapse when space runs out.</p>
	</div>
</Story>

<Story name="Min item width" args={{ minItemWidth: '14rem' }}>
	<div class="card tall">
		<h4>One</h4>
		<p>Lower the threshold to keep more items per row.</p>
	</div>
	<div class="card tall">
		<h4>Two</h4>
		<p>Lower the threshold to keep more items per row.</p>
	</div>
	<div class="card tall">
		<h4>Three</h4>
		<p>Lower the threshold to keep more items per row.</p>
	</div>
	<div class="card tall">
		<h4>Four</h4>
		<p>Lower the threshold to keep more items per row.</p>
	</div>
</Story>

<style>
	.card {
		display: grid;
		gap: 0.5rem;
		padding: 1rem;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background) 55%, #000);
		min-height: 7rem;
	}

	.card.tall {
		min-height: 8rem;
	}
</style>

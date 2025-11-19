<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Center from './Center.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Center',
		component: Center,
		tags: ['autodocs'],
		args: {
			maxWidth: '60ch',
			gutter: '1.25rem',
			intrinsic: false
		},
		argTypes: {
			maxWidth: { control: { type: 'text' } },
			gutter: { control: { type: 'text' } },
			intrinsic: { control: { type: 'boolean' } }
		}
	});
</script>

<Story name="Readable Column">
	<div class="body-copy">
		<p>The center layout keeps measure comfortable and leaves space at the edges.</p>
		<p>Adjust <code>maxWidth</code> or <code>gutter</code> to fit marketing or doc layouts.</p>
	</div>
</Story>

<Story name="Intrinsic" args={{ intrinsic: true }}>
	<div class="card">
		<h3>Call to action</h3>
		<p>Great for hero buttons or small feature cards.</p>
		<button type="button">Do the thing</button>
	</div>
</Story>

<style>
	.body-copy {
		display: grid;
		gap: 0.75rem;
		line-height: 1.6;
		font-size: 1rem;
	}

	.card {
		display: grid;
		gap: 0.5rem;
		align-items: center;
		justify-items: center;
		padding: 1.5rem;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background) 70%, #000);
		text-align: center;
	}

	button {
		padding: 0.5rem 1rem;
		border-radius: 9999px;
		border: 1px solid currentColor;
		background: transparent;
		cursor: pointer;
	}
</style>

<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Card from './Card.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Card',
		component: Card,
		tags: ['autodocs'],
		args: {
			padding: '1rem',
			radius: '0.75rem'
		},
		argTypes: {
			padding: { control: { type: 'text' } },
			radius: { control: { type: 'text' } },
			shadow: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Default">
	<h3>Simple card</h3>
	<p>Use for small summaries or compact content blocks.</p>
</Story>

<Story name="Raised" args={{ shadow: '0 10px 30px rgba(0,0,0,0.2)' }}>
	<h3>Raised card</h3>
	<p>Shadow adds emphasis for callouts or modals.</p>
</Story>

<style>
	h3 {
		margin: 0;
	}

	p {
		margin: 0;
		line-height: 1.5;
	}
</style>

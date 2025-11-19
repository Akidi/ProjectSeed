<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Cover from './Cover.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Cover',
		component: Cover,
		tags: ['autodocs'],
		args: {
			minHeight: '70vh',
			padding: '2rem',
			gap: '1.5rem',
			align: 'center',
			justify: 'center'
		},
		argTypes: {
			minHeight: { control: { type: 'text' } },
			padding: { control: { type: 'text' } },
			gap: { control: { type: 'text' } },
			align: { control: { type: 'text' } },
			justify: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Hero">
	<p class="eyebrow">New release</p>
	<h1>Design boldly.<br />Ship confidently.</h1>
	<p class="lede">
		A flexible cover layout to center your hero content while keeping breathing room.
	</p>
	<div class="actions">
		<button class="primary">Get started</button>
		<button class="ghost">Learn more</button>
	</div>
</Story>

<Story
	name="Top Aligned"
	args={{ justify: 'flex-start', align: 'flex-start', minHeight: '80vh', padding: '3rem' }}
>
	<p class="eyebrow">Docs</p>
	<h2>Readable cover</h2>
	<p class="lede">
		Use top alignment for documentation or marketing sections that need plenty of text.
	</p>
	<div class="panel">
		<p>Place cards, intro copy, or navigation here.</p>
	</div>
</Story>

<style>
	.eyebrow {
		text-transform: uppercase;
		letter-spacing: 0.08em;
		font-size: 0.8rem;
		color: color-mix(in srgb, var(--storybook-foreground) 70%, var(--storybook-background));
	}

	h1,
	h2 {
		margin: 0;
	}

	.lede {
		max-width: 48ch;
		line-height: 1.6;
	}

	.actions {
		display: flex;
		gap: 0.75rem;
	}

	.primary {
		padding: 0.65rem 1.25rem;
		border-radius: 999px;
		border: none;
		background: color-mix(in srgb, var(--storybook-foreground) 90%, #000);
		color: var(--storybook-background);
		font-weight: 700;
		cursor: pointer;
	}

	.ghost {
		padding: 0.65rem 1.25rem;
		border-radius: 999px;
		border: 1px solid currentColor;
		background: transparent;
		cursor: pointer;
	}

	.panel {
		padding: 1rem 1.25rem;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background) 65%, #000);
	}
</style>

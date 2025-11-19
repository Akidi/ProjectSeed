<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Frame from './Frame.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Frame',
		component: Frame,
		tags: ['autodocs'],
		args: {
			ratio: '16 / 9',
			maxHeight: 'none',
			cover: false
		},
		argTypes: {
			ratio: { control: { type: 'text' } },
			maxHeight: { control: { type: 'text' } },
			cover: { control: { type: 'boolean' } }
		}
	});
</script>

<Story name="Video placeholder">
	<div class="frame-content">16:9</div>
</Story>

<Story name="Portrait" args={{ ratio: '3 / 4', maxHeight: '28rem' }}>
	<div class="frame-content portrait">3:4</div>
</Story>

<Story name="Cover media" args={{ cover: true }}>
	<img
		src="https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=800&q=80"
		alt="Mountains"
		loading="lazy"
	/>
</Story>

<style>
	.frame-content {
		width: 100%;
		height: 100%;
		display: grid;
		place-items: center;
		font-weight: 700;
		color: color-mix(in srgb, var(--storybook-foreground) 90%, #000);
	}

	.frame-content.portrait {
		background: color-mix(in srgb, var(--storybook-background) 60%, #000);
	}

	img {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
</style>

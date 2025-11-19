<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type FrameProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		ratio?: string;
		maxHeight?: string;
		cover?: boolean;
		children?: Snippet;
	};

	let {
		as = 'div',
		ratio = '16 / 9',
		maxHeight = 'none',
		cover = false,
		class: className = '',
		style = '',
		children,
		...restProps
	}: FrameProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` + `--frame-ratio:${ratio};--frame-max:${maxHeight};`
	);

	const classes = $derived(`frame ${cover ? 'frame--cover' : ''} ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.frame {
		position: relative;
		display: grid;
		place-items: center;
		aspect-ratio: var(--frame-ratio, 16 / 9);
		max-height: var(--frame-max, none);
		overflow: hidden;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background, #111) 60%, #000);
	}

	.frame--cover :global(img),
	.frame--cover :global(video),
	.frame--cover :global(picture > img) {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
</style>

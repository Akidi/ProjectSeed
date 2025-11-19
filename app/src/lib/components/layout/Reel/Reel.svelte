<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type ReelProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		gap?: string;
		itemWidth?: string;
		snap?: boolean;
		children?: Snippet;
	};

	let {
		as = 'div',
		gap = 'var(--space-4, 1rem)',
		itemWidth = 'var(--tile-min-width, 16rem)',
		snap = true,
		class: className = '',
		style = '',
		children,
		...restProps
	}: ReelProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` + `--reel-gap:${gap};--reel-item-width:${itemWidth};`
	);

	const classes = $derived(`reel ${snap ? 'reel--snap' : ''} ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.reel {
		display: flex;
		gap: var(--reel-gap, 1rem);
		overflow-x: auto;
		overscroll-behavior-x: contain;
		padding-block: 0.25rem;
		scrollbar-width: thin;
		scrollbar-color: color-mix(in srgb, currentColor 40%, transparent) transparent;
	}

	:global(.reel > *) {
		flex: 0 0 var(--reel-item-width, 16rem);
	}

	.reel--snap {
		scroll-snap-type: x mandatory;
	}

	:global(.reel--snap > *) {
		scroll-snap-align: start;
	}
</style>

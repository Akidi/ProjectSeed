<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type SwitcherProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		gap?: string;
		minItemWidth?: string;
		children?: Snippet;
	};

	let {
		as = 'div',
		gap = 'var(--space-4, 1rem)',
		minItemWidth = 'var(--tile-min-width, 18rem)',
		class: className = '',
		style = '',
		children,
		...restProps
	}: SwitcherProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` + `--switcher-gap:${gap};--switcher-min:${minItemWidth};`
	);

	const classes = $derived(`switcher ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.switcher {
		display: flex;
		flex-wrap: wrap;
		gap: var(--switcher-gap, 1rem);
	}

	:global(.switcher > *) {
		flex-grow: 1;
		flex-basis: calc((var(--switcher-min, 18rem) - 100%) * 999);
		min-width: var(--switcher-min, 18rem);
	}
</style>

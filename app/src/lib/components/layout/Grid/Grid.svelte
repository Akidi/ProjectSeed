<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type GridProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		gap?: string;
		minItemWidth?: string;
		align?: string;
		children?: Snippet;
	};

	let {
		as = 'div',
		gap = '1rem',
		minItemWidth = '16rem',
		align = 'stretch',
		class: className = '',
		style = '',
		children,
		...restProps
	}: GridProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` +
			`--grid-gap:${gap};--grid-min:${minItemWidth};--grid-align:${align};`
	);

	const classes = $derived(`grid ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.grid {
		display: grid;
		gap: var(--grid-gap, 1rem);
		align-items: var(--grid-align, stretch);
		grid-template-columns: repeat(auto-fit, minmax(var(--grid-min, 16rem), 1fr));
	}
</style>

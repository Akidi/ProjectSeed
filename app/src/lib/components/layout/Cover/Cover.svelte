<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type CoverProps<T extends keyof HTMLElementTagNameMap = 'section'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		minHeight?: string;
		padding?: string;
		gap?: string;
		align?: string;
		justify?: string;
		children?: Snippet;
	};

	let {
		as = 'section',
		minHeight = '100vh',
		padding = '2rem',
		gap = '1.5rem',
		align = 'center',
		justify = 'center',
		class: className = '',
		style = '',
		children,
		...restProps
	}: CoverProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` +
			`--cover-height:${minHeight};--cover-padding:${padding};` +
			`--cover-gap:${gap};--cover-align:${align};--cover-justify:${justify};`
	);

	const classes = $derived(`cover ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.cover {
		min-height: var(--cover-height, 100vh);
		display: flex;
		flex-direction: column;
		justify-content: var(--cover-justify, center);
		align-items: var(--cover-align, center);
		gap: var(--cover-gap, 1.5rem);
		padding: var(--cover-padding, 2rem);
	}
</style>

<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type CardProps<T extends keyof HTMLElementTagNameMap = 'article'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		padding?: string;
		radius?: string;
		border?: string;
		shadow?: string;
		background?: string;
		children?: Snippet;
	};

	let {
		as = 'article',
		padding = '1rem',
		radius = '0.75rem',
		border = '1px solid color-mix(in srgb, currentColor 20%, transparent)',
		shadow = '',
		background = 'color-mix(in srgb, var(--storybook-background, #111) 70%, #000)',
		class: className = '',
		style = '',
		children,
		...restProps
	}: CardProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` +
			`--card-padding:${padding};--card-radius:${radius};--card-border:${border};` +
			`--card-shadow:${shadow};--card-bg:${background};`
	);

	const classes = $derived(`card ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.card {
		display: grid;
		gap: 0.75rem;
		padding: var(--card-padding, 1rem);
		border-radius: var(--card-radius, 0.75rem);
		border: var(--card-border, 1px solid color-mix(in srgb, currentColor 20%, transparent));
		background: var(--card-bg, color-mix(in srgb, var(--storybook-background, #111) 70%, #000));
		box-shadow: var(--card-shadow);
	}
</style>

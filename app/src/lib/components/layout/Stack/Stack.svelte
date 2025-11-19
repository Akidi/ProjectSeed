<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type StackProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		gap?: string;
		align?: string;
		justify?: string;
		maxWidth?: string;
		children?: Snippet;
	};

	let {
		as = 'div',
		gap = '1rem',
		align = 'stretch',
		justify = 'flex-start',
		maxWidth,
		class: className = '',
		style = '',
		children,
		...restProps
	}: StackProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` +
			`${maxWidth ? `max-width:${maxWidth};` : ''}` +
			`--stack-gap:${gap};--stack-align:${align};--stack-justify:${justify};`
	);

	const classes = $derived(`stack ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.stack {
		display: flex;
		flex-direction: column;
		align-items: var(--stack-align, stretch);
		justify-content: var(--stack-justify, flex-start);
		gap: var(--stack-gap, 1rem);
		width: 100%;
	}
</style>

<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type ClusterProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		gap?: string;
		align?: string;
		justify?: string;
		children?: Snippet;
	};

	let {
		as = 'div',
		gap = 'var(--space-3, 0.75rem)',
		align = 'center',
		justify = 'flex-start',
		class: className = '',
		style = '',
		children,
		...restProps
	}: ClusterProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` +
			`--cluster-gap:${gap};--cluster-align:${align};--cluster-justify:${justify};`
	);

	const classes = $derived(`cluster ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.cluster {
		display: flex;
		flex-wrap: wrap;
		gap: var(--cluster-gap, 1rem);
		align-items: var(--cluster-align, center);
		justify-content: var(--cluster-justify, flex-start);
	}
</style>

<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type CenterProps<T extends keyof HTMLElementTagNameMap = 'div'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		maxWidth?: string;
		gutter?: string;
		intrinsic?: boolean;
		children?: Snippet;
	};

	let {
		as = 'div',
		maxWidth = '65ch',
		gutter = '1rem',
		intrinsic = false,
		class: className = '',
		style = '',
		children,
		...restProps
	}: CenterProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` + `--center-max:${maxWidth};--center-gutter:${gutter};`
	);

	const classes = $derived(`center ${intrinsic ? 'center--intrinsic' : ''} ${className}`.trim());
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.center {
		box-sizing: content-box;
		margin-inline: auto;
		max-inline-size: var(--center-max, 65ch);
		padding-inline: var(--center-gutter, 1rem);
	}

	.center--intrinsic {
		display: flex;
		flex-direction: column;
		align-items: center;
	}
</style>

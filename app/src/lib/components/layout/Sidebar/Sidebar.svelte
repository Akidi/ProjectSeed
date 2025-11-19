<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type SidebarSide = 'left' | 'right';

	type SidebarProps<T extends keyof HTMLElementTagNameMap = 'section'> = HTMLAttributes<
		HTMLElementTagNameMap[T]
	> & {
		as?: T;
		gap?: string;
		align?: string;
		side?: SidebarSide;
		sidebarWidth?: string;
		contentMin?: string;
		children?: Snippet;
	};

	let {
		as = 'section',
		gap = 'var(--space-4, 1rem)',
		align = 'flex-start',
		side = 'left',
		sidebarWidth = 'var(--sidebar-width, 18rem)',
		contentMin = '22rem',
		class: className = '',
		style = '',
		children,
		...restProps
	}: SidebarProps<keyof HTMLElementTagNameMap> = $props();

	const elementProps = restProps as HTMLAttributes<HTMLElementTagNameMap[typeof as]>;

	const inlineStyle = $derived(
		`${style ? `${style};` : ''}` +
			`--sidebar-gap:${gap};--sidebar-align:${align};` +
			`--sidebar-width:${sidebarWidth};--sidebar-content-min:${contentMin};`
	);

	const classes = $derived(
		`sidebar ${side === 'right' ? 'sidebar--right' : ''} ${className}`.trim()
	);
</script>

<svelte:element this={as} class={classes} style={inlineStyle} {...elementProps}>
	{@render children?.()}
</svelte:element>

<style>
	.sidebar {
		display: flex;
		flex-wrap: wrap;
		gap: var(--sidebar-gap, 1rem);
		align-items: var(--sidebar-align, flex-start);
	}

	:global(.sidebar > :first-child) {
		flex-basis: var(--sidebar-width, 18rem);
		flex-grow: 1;
	}

	:global(.sidebar > :last-child) {
		flex-grow: 999;
		flex-basis: 0;
		min-width: min(var(--sidebar-content-min, 22rem), 100%);
	}

	:global(.sidebar.sidebar--right > :first-child) {
		order: 1;
	}
</style>

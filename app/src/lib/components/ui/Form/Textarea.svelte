<script lang="ts">
	import type { SvelteHTMLElements } from 'svelte/elements';

	type TextareaProps = SvelteHTMLElements['textarea'] & {
		variant?: 'default' | 'ghost';
		rows?: number;
	};

	let {
		variant = 'default',
		rows = 4,
		class: className = '',
		...restProps
	}: TextareaProps = $props();

	const classes = $derived(
		['ui-textarea', `ui-textarea--${variant}`, className].filter(Boolean).join(' ')
	);
</script>

<textarea class={classes} {rows} {...restProps}></textarea>

<style>
	.ui-textarea {
		width: 100%;
		padding: var(--space-3, 0.75rem);
		border-radius: var(--radius-md, 0.5rem);
		border: 1px solid var(--color-border, #e0e0e0);
		background: var(--color-surface-1, #fff);
		color: var(--color-text);
		resize: vertical;
		min-height: 6rem;
	}

	.ui-textarea:focus {
		outline: 2px solid color-mix(in srgb, var(--color-accent) 80%, #fff);
		outline-offset: 2px;
	}

	.ui-textarea--ghost {
		background: transparent;
	}
</style>

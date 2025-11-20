<script lang="ts">
	import type { SvelteHTMLElements } from 'svelte/elements';

	type InputProps = SvelteHTMLElements['input'] & {
		variant?: 'default' | 'ghost';
	};

	let { variant = 'default', class: className = '', ...restProps }: InputProps = $props();

	const classes = $derived(
		['ui-input', `ui-input--${variant}`, className].filter(Boolean).join(' ')
	);
</script>

<input class={classes} {...restProps} />

<style>
	.ui-input {
		width: 100%;
		padding: var(--space-3, 0.75rem);
		border-radius: var(--radius-md, 0.5rem);
		border: 1px solid var(--color-border, #e0e0e0);
		background: var(--color-surface-1, #fff);
		color: var(--color-text);
	}

	.ui-input:focus {
		outline: 2px solid color-mix(in srgb, var(--color-accent) 80%, #fff);
		outline-offset: 2px;
	}

	.ui-input--ghost {
		background: transparent;
	}
</style>

<script lang="ts">
	import type { Snippet } from 'svelte';

	type AlertVariant = 'info' | 'success' | 'warning' | 'error';

	type AlertProps = {
		variant?: AlertVariant;
		title?: string;
		children?: Snippet;
	};

	let { variant = 'info', title, children }: AlertProps = $props();
</script>

<div class={`ui-alert ui-alert--${variant}`} role="status">
	{#if title}<strong>{title}</strong>{/if}
	{@render children?.()}
</div>

<style>
	.ui-alert {
		padding: var(--space-3, 0.75rem);
		border-radius: var(--radius-lg, 0.75rem);
		border: 1px solid transparent;
		display: grid;
		gap: var(--space-2, 0.5rem);
		background: var(--color-surface-2, #f3f3f3);
		color: var(--color-text);
	}

	.ui-alert--info {
		border-color: var(--color-border, #d0d0d0);
	}

	.ui-alert--success {
		border-color: oklch(0.7 0.14 150);
	}

	.ui-alert--warning {
		border-color: oklch(0.78 0.15 85);
	}

	.ui-alert--error {
		border-color: oklch(0.65 0.22 25);
	}
</style>

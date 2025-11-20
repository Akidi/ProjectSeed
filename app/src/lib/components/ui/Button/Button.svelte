<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { SvelteHTMLElements } from 'svelte/elements';

	type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'destructive';
	type ButtonSize = 'sm' | 'md' | 'lg';

	type ButtonProps = SvelteHTMLElements['button'] & {
		variant?: ButtonVariant;
		size?: ButtonSize;
		fullWidth?: boolean;
		loading?: boolean;
		children?: Snippet;
	};

	type $$Events = {
		click: MouseEvent;
	};

	let {
		variant = 'primary',
		size = 'md',
		fullWidth = false,
		loading = false,
		class: className = '',
		children,
		...restProps
	}: ButtonProps = $props();

	const buttonProps = restProps as SvelteHTMLElements['button'];
	const isDisabled = $derived(Boolean(buttonProps.disabled) || loading);

	const classes = $derived(
		[
			'ui-button',
			`ui-button--${variant}`,
			`ui-button--${size}`,
			fullWidth ? 'ui-button--block' : '',
			loading ? 'ui-button--loading' : '',
			className
		]
			.filter(Boolean)
			.join(' ')
	);
</script>

<button class={classes} disabled={isDisabled} {...buttonProps}>
	<span class="ui-button__content">
		{@render children?.()}
	</span>
	{#if loading}
		<span class="ui-button__spinner" aria-hidden="true"></span>
	{/if}
</button>

<style>
	.ui-button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: var(--space-2, 0.5rem);
		border-radius: var(--radius-md, 0.5rem);
		border: 1px solid transparent;
		padding: var(--space-2, 0.5rem) var(--space-4, 1rem);
		font-weight: 600;
		line-height: 1.2;
		cursor: pointer;
		background: transparent;
		color: var(--color-text);
		transition:
			background-color 150ms ease,
			color 150ms ease,
			border-color 150ms ease,
			transform 120ms ease;
	}

	.ui-button:disabled {
		opacity: 0.6;
		cursor: not-allowed;
	}

	.ui-button--block {
		width: 100%;
	}

	.ui-button--primary {
		background: var(--color-accent);
		color: var(--color-accent-contrast, #0a0a0a);
	}

	.ui-button--primary:hover:not(:disabled) {
		filter: brightness(0.95);
	}

	.ui-button--secondary {
		background: var(--color-surface-2, #f3f3f3);
		border-color: var(--color-border, #e0e0e0);
	}

	.ui-button--ghost {
		border-color: var(--color-border, #e0e0e0);
		background: transparent;
	}

	.ui-button--destructive {
		background: oklch(0.63 0.21 25);
		color: white;
	}

	.ui-button--sm {
		padding: var(--space-1, 0.25rem) var(--space-3, 0.75rem);
		font-size: 0.9rem;
	}

	.ui-button--md {
		font-size: 1rem;
	}

	.ui-button--lg {
		padding: var(--space-3, 0.75rem) var(--space-5, 1.25rem);
		font-size: 1.05rem;
	}

	.ui-button__spinner {
		width: 1em;
		aspect-ratio: 1;
		border-radius: 50%;
		border: 2px solid currentColor;
		border-right-color: transparent;
		animation: spin 700ms linear infinite;
	}

	@keyframes spin {
		to {
			transform: rotate(360deg);
		}
	}
</style>

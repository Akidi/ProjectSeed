<script lang="ts">
	import { toasts, dismissToast, type ToastItem } from './store';
	import Button from '../Button/Button.svelte';
	import { derived } from 'svelte/store';

	const list = derived(toasts, (t) => t);
</script>

<div class="ui-toaster" aria-live="polite">
	{#each $list as toast (toast.id)}
		<div class={`ui-toast ui-toast--${toast.variant ?? 'default'}`}>
			<div class="ui-toast__content">
				{#if toast.title}<strong>{toast.title}</strong>{/if}
				{#if toast.description}<p>{toast.description}</p>{/if}
			</div>
			<Button variant="ghost" aria-label="Dismiss" onclick={() => dismissToast(toast.id)}>×</Button>
		</div>
	{/each}
</div>

<style>
	.ui-toaster {
		position: fixed;
		z-index: 60;
		inset: auto var(--space-5, 1.25rem) var(--space-5, 1.25rem) auto;
		display: grid;
		gap: var(--space-3, 0.75rem);
		width: min(26rem, 95vw);
	}

	.ui-toast {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-3, 0.75rem);
		padding: var(--space-3, 0.75rem);
		border-radius: var(--radius-lg, 0.75rem);
		border: 1px solid var(--color-border, #e0e0e0);
		background: var(--color-surface-2, #f3f3f3);
		box-shadow: var(--shadow-soft, 0 10px 30px rgba(0, 0, 0, 0.12));
	}

	.ui-toast--success {
		border-color: oklch(0.7 0.14 150);
	}

	.ui-toast--warning {
		border-color: oklch(0.78 0.15 85);
	}

	.ui-toast--error {
		border-color: oklch(0.65 0.22 25);
	}

	.ui-toast__content p {
		margin: 0;
		color: var(--color-muted, #666);
	}
</style>

<script lang="ts">
	import type { Snippet } from 'svelte';
	import Card from '$lib/components/layout/Card/Card.svelte';

	type ModalProps = {
		open?: boolean;
		title?: string;
		maxWidth?: string;
		children?: Snippet;
		actions?: Snippet;
		onClose?: () => void;
	};

	let {
		open = false,
		title,
		maxWidth = '32rem',
		children,
		actions,
		onClose
	}: ModalProps = $props();

	const close = () => {
		onClose?.();
	};
</script>

{#if open}
	<div class="ui-modal" role="dialog" aria-modal="true" aria-label={title}>
		<button type="button" class="ui-modal__backdrop" aria-label="Close" onclick={close}></button>
		<div class="ui-modal__shell" style={`max-width:${maxWidth}`}>
			<Card class="ui-modal__card">
				<div class="ui-modal__header">
					{#if title}
						<h3>{title}</h3>
					{/if}
					<button type="button" class="ui-modal__close" onclick={close} aria-label="Close">
						×
					</button>
				</div>
				<div class="ui-modal__body">
					{@render children?.()}
				</div>
				{#if actions}
					<div class="ui-modal__footer">
						{@render actions()}
					</div>
				{/if}
			</Card>
		</div>
	</div>
{/if}

<style>
	.ui-modal {
		position: fixed;
		inset: 0;
		display: grid;
		place-items: center;
		z-index: 50;
	}

	.ui-modal__backdrop {
		position: absolute;
		inset: 0;
		background: color-mix(in srgb, var(--color-surface-1, #000) 50%, transparent);
		backdrop-filter: blur(4px);
	}

	.ui-modal__shell {
		position: relative;
		width: min(90vw, var(--content-width, 70ch));
		padding: var(--space-4, 1rem);
	}

	:global(.ui-modal__card) {
		box-shadow: var(--shadow-soft, 0 14px 40px rgba(0, 0, 0, 0.25));
		background: var(--color-surface-1, #fff);
		border: 1px solid var(--color-border, #e0e0e0);
	}

	.ui-modal__header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-2, 0.5rem);
	}

	.ui-modal__body {
		margin-top: var(--space-4, 1rem);
	}

	.ui-modal__footer {
		margin-top: var(--space-4, 1rem);
		display: flex;
		gap: var(--space-3, 0.75rem);
		justify-content: flex-end;
	}

	.ui-modal__close {
		border: none;
		background: transparent;
		font-size: 1.25rem;
		cursor: pointer;
		color: var(--color-muted, #666);
	}
</style>

<script lang="ts">
	import Stack from '$lib/components/layout/Stack/Stack.svelte';
	import type { Snippet } from 'svelte';

	type FieldProps = {
		label?: string;
		hint?: string;
		error?: string;
		required?: boolean;
		inputId?: string;
		children?: Snippet;
	};

	let { label, hint, error, required = false, inputId, children }: FieldProps = $props();
</script>

<div class="ui-field">
	{#if label}
		<label class="ui-field__label" for={inputId}>
			<span>{label}</span>
			{#if required}
				<span aria-hidden="true" class="ui-field__required">*</span>
			{/if}
		</label>
	{/if}

	<div class="ui-field__control">
		{@render children?.()}
	</div>

	{#if hint}
		<p class="ui-field__hint">{hint}</p>
	{/if}
	{#if error}
		<p class="ui-field__error" role="alert">{error}</p>
	{/if}
</div>

<style>
	.ui-field {
		display: grid;
		gap: var(--space-2, 0.5rem);
	}

	.ui-field__label {
		display: inline-flex;
		align-items: center;
		gap: var(--space-1, 0.25rem);
		font-weight: 600;
		color: var(--color-text);
	}

	.ui-field__required {
		color: oklch(0.63 0.21 25);
	}

	.ui-field__hint {
		font-size: 0.9rem;
		color: var(--color-muted, #666);
	}

	.ui-field__error {
		font-size: 0.9rem;
		color: oklch(0.65 0.22 25);
	}
</style>

<script lang="ts">
	import Stack from '$lib/components/layout/Stack/Stack.svelte';
	import type { Snippet } from 'svelte';
	import type { HTMLAttributes } from 'svelte/elements';

	type FormProps = HTMLAttributes<HTMLFormElement> & {
		gap?: string;
		actions?: Snippet;
		children?: Snippet;
	};

	let { gap = 'var(--space-5, 1.25rem)', actions, children, ...restProps }: FormProps = $props();

	const formProps = restProps as any;
</script>

<Stack as="form" {gap} {...formProps}>
	{@render children?.()}
	{#if actions}
		<div class="form-actions">{@render actions()}</div>
	{/if}
</Stack>

<style>
	.form-actions {
		display: flex;
		gap: var(--space-3, 0.75rem);
		justify-content: flex-end;
	}
</style>

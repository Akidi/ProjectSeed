<script lang="ts">
	import Cluster from '$lib/components/layout/Cluster/Cluster.svelte';
	import type { Snippet } from 'svelte';

	type ButtonGroupProps = {
		orientation?: 'horizontal' | 'vertical';
		gap?: string;
		children?: Snippet;
	};

	let {
		orientation = 'horizontal',
		gap = 'var(--space-3, 0.75rem)',
		children
	}: ButtonGroupProps = $props();

	const directionClass = $derived(
		orientation === 'vertical' ? 'ui-button-group--vertical' : 'ui-button-group--horizontal'
	);
</script>

<div class={`ui-button-group ${directionClass}`}>
	<Cluster {gap} align="center" justify="flex-start">
		{@render children?.()}
	</Cluster>
	{#if directionClass === 'ui-button-group--vertical'}
		<!-- spacer to prevent unused selector warning -->
	{/if}
</div>

<style>
	.ui-button-group {
		width: fit-content;
	}

	:global(.ui-button-group--vertical .cluster) {
		flex-direction: column;
		align-items: stretch;
	}
</style>

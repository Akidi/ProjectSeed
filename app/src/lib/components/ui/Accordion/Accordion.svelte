<script lang="ts">
	export type AccordionItem = {
		id: string;
		title: string;
		content: string;
	};

	type AccordionProps = {
		items?: AccordionItem[];
		multiple?: boolean;
	};

	let { items = [], multiple = false }: AccordionProps = $props();
	let openIds = $state<string[]>([]);

	const toggle = (id: string) => {
		if (multiple) {
			openIds = openIds.includes(id) ? openIds.filter((x) => x !== id) : [...openIds, id];
		} else {
			openIds = openIds.includes(id) ? [] : [id];
		}
	};
	const isOpen = (id: string) => openIds.includes(id);
</script>

<div class="ui-accordion">
	{#each items as item (item.id)}
		<div class="ui-accordion__item">
			<button
				type="button"
				class="ui-accordion__trigger"
				aria-expanded={isOpen(item.id)}
				onclick={() => toggle(item.id)}
			>
				<span>{item.title}</span>
				<span aria-hidden="true">{isOpen(item.id) ? '−' : '+'}</span>
			</button>
			{#if isOpen(item.id)}
				<div class="ui-accordion__panel">
					{item.content}
				</div>
			{/if}
		</div>
	{/each}
</div>

<style>
	.ui-accordion {
		display: grid;
		gap: var(--space-3, 0.75rem);
	}

	.ui-accordion__item {
		border: 1px solid var(--color-border, #e0e0e0);
		border-radius: var(--radius-lg, 0.75rem);
		background: var(--color-surface-1, #fff);
	}

	.ui-accordion__trigger {
		width: 100%;
		text-align: left;
		padding: var(--space-3, 0.75rem);
		background: transparent;
		border: none;
		display: flex;
		justify-content: space-between;
		align-items: center;
		cursor: pointer;
		font-weight: 600;
	}

	.ui-accordion__panel {
		padding: 0 var(--space-3, 0.75rem) var(--space-3, 0.75rem);
		color: var(--color-text);
	}
</style>

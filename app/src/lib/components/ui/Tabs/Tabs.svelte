<script lang="ts">
	type Tab = {
		id: string;
		label: string;
		panel: string;
	};

	type TabsProps = {
		items?: Tab[];
		activeId?: string;
	};

	let { items = [], activeId }: TabsProps = $props();

	let current = $state(activeId ?? items[0]?.id);

	const select = (id: string) => {
		current = id;
	};

	const onKey = (event: KeyboardEvent) => {
		const idx = items.findIndex((t) => t.id === current);
		if (idx === -1) return;
		if (event.key === 'ArrowRight') {
			current = items[(idx + 1) % items.length]?.id;
			event.preventDefault();
		} else if (event.key === 'ArrowLeft') {
			current = items[(idx - 1 + items.length) % items.length]?.id;
			event.preventDefault();
		}
	};
</script>

<div class="ui-tabs">
	<div class="ui-tabs__list" role="tablist" tabindex="0" onkeydown={onKey}>
		{#each items as tab (tab.id)}
			<button
				type="button"
				role="tab"
				class={`ui-tabs__tab ${current === tab.id ? 'is-active' : ''}`}
				aria-selected={current === tab.id}
				tabindex={current === tab.id ? 0 : -1}
				onclick={() => select(tab.id)}
			>
				{tab.label}
			</button>
		{/each}
	</div>
	{#if items.length}
		{#each items as tab (tab.id)}
			{#if tab.id === current}
				<div class="ui-tabs__panel" role="tabpanel" aria-label={tab.label}>
					{tab.panel}
				</div>
			{/if}
		{/each}
	{/if}
</div>

<style>
	.ui-tabs {
		display: grid;
		gap: var(--space-4, 1rem);
	}

	.ui-tabs__list {
		display: flex;
		gap: var(--space-2, 0.5rem);
		border-bottom: 1px solid var(--color-border, #e0e0e0);
	}

	.ui-tabs__tab {
		padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
		border: none;
		background: transparent;
		border-radius: var(--radius-md, 0.5rem) var(--radius-md, 0.5rem) 0 0;
		cursor: pointer;
		color: var(--color-muted, #666);
	}

	.ui-tabs__tab.is-active {
		color: var(--color-text);
		background: var(--color-surface-2, #f3f3f3);
		border: 1px solid var(--color-border, #e0e0e0);
		border-bottom-color: transparent;
	}

	.ui-tabs__panel {
		padding: var(--space-4, 1rem);
		border: 1px solid var(--color-border, #e0e0e0);
		border-radius: var(--radius-md, 0.5rem);
		background: var(--color-surface-1, #fff);
	}
</style>

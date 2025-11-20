<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Tabs from './Tabs.svelte';

	const items = [
		{ id: 'one', label: 'One', panel: 'Tab one content' },
		{ id: 'two', label: 'Two', panel: 'Second tab content' },
		{ id: 'three', label: 'Three', panel: 'Third tab' }
	];

	const { Story } = defineMeta({
		title: 'UI/Tabs',
		component: Tabs,
		tags: ['autodocs'],
		args: { items }
	});
</script>

<Story name="Default" />

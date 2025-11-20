<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Accordion from './Accordion.svelte';

	const items = [
		{ id: 'a', title: 'Section A', content: 'Content for section A' },
		{ id: 'b', title: 'Section B', content: 'Content for section B' },
		{ id: 'c', title: 'Section C', content: 'Content for section C' }
	];

	const { Story } = defineMeta({
		title: 'UI/Accordion',
		component: Accordion,
		tags: ['autodocs'],
		args: { items }
	});
</script>

<Story name="Single open" />

<Story name="Multiple" args={{ multiple: true }} />

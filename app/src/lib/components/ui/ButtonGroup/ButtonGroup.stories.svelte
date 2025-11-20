<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import ButtonGroup from './ButtonGroup.svelte';
	import Button from '../Button/Button.svelte';

	const { Story } = defineMeta({
		title: 'UI/ButtonGroup',
		component: ButtonGroup,
		tags: ['autodocs']
	});
</script>

<Story name="default">
	<Button variant="primary">One</Button>
	<Button variant="secondary">Two</Button>
	<Button variant="ghost">Three</Button>
	<Button variant="destructive">Four</Button>
</Story>

<Story name="Vertical" args={{ orientation: 'vertical' }}>
	<Button>Primary</Button>
	<Button variant="secondary">Secondary</Button>
	<Button variant="ghost">Ghost</Button>
</Story>

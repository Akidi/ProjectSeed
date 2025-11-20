<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Modal from './Modal.svelte';
	import Button from '../Button/Button.svelte';
	import { fn } from 'storybook/test';

	const onClose = fn().mock;

	const { Story } = defineMeta({
		title: 'UI/Modal',
		component: Modal,
		tags: ['autodocs'],
		args: { open: true, title: 'Modal title' }
	});
</script>

<Story name="Default" args={{ onClose, open: true, title: 'Modal Title' }}>
	<p>This modal uses the Card layout and tokens for spacing.</p>
	{#snippet actions()}
		<Button variant="ghost" type="button">Cancel</Button>
		<Button type="button">Confirm</Button>
	{/snippet}
</Story>

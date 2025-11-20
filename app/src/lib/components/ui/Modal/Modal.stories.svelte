<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Modal from './Modal.svelte';
	import Button from '../Button/Button.svelte';

	const { Story } = defineMeta({
		title: 'UI/Modal',
		component: Modal,
		tags: ['autodocs'],
		args: { open: true, title: 'Modal title' }
	});
</script>

<Story name="Default" args={{}}>
	<Modal open title="Modal title" onClose={() => {}}>
		<p>This modal uses the Card layout and tokens for spacing.</p>
		{#snippet actions()}
			<Button variant="ghost" type="button">Cancel</Button>
			<Button type="button">Confirm</Button>
		{/snippet}
	</Modal>
</Story>

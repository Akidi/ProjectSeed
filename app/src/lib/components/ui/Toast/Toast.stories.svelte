<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Toaster from './Toaster.svelte';
	import { toast, toastSuccess, toastError } from './toast';
	import Button from '../Button/Button.svelte';

	const { Story } = defineMeta({
		title: 'UI/Toast',
		component: Toaster,
		tags: ['autodocs']
	});
</script>

<Story name="Toasts">
	<Toaster />
	<div style="display:flex; gap:0.75rem;">
		<Button on:click={() => toast({ title: 'Hello', description: 'Default toast' })}>Default</Button
		>
		<Button variant="secondary" on:click={() => toastSuccess('Saved!')}>Success</Button>
		<Button variant="destructive" on:click={() => toastError('Something went wrong')}>Error</Button>
	</div>
</Story>

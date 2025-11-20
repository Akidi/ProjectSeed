<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Alert from './Alert.svelte';

	const { Story } = defineMeta({
		title: 'UI/Alert',
		component: Alert,
		tags: ['autodocs']
	});
</script>

<Story name="Info">
	<Alert title="Heads up">This is an informational alert.</Alert>
</Story>

<Story name="Success">
	<Alert variant="success" title="Done">Your changes have been saved.</Alert>
</Story>

<Story name="Warning">
	<Alert variant="warning" title="Warning">Please double-check these values.</Alert>
</Story>

<Story name="Error">
	<Alert variant="error" title="Error">Something went wrong.</Alert>
</Story>

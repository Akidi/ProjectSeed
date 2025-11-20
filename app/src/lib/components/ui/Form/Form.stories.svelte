<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Form from './Form.svelte';
	import Field from './Field.svelte';
	import Input from './Input.svelte';
	import Textarea from './Textarea.svelte';
	import Button from '../Button/Button.svelte';

	const { Story } = defineMeta({
		title: 'UI/Form',
		component: Form,
		tags: ['autodocs']
	});
</script>

<Story name="Basic form">
	<Field label="Name" hint="Your full name">
		<Input placeholder="Jane Doe" />
	</Field>
	<Field label="Message" hint="Optional">
		<Textarea placeholder="Tell us more..." />
	</Field>

	<Button variant="ghost" type="button">Cancel</Button>
	<Button type="submit">Submit</Button>
</Story>

<Story name="With error">
	<Field label="Email" error="This email is invalid">
		<Input type="email" placeholder="you@example.com" aria-invalid="true" />
	</Field>
</Story>

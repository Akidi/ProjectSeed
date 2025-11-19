<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Sidebar from './Sidebar.svelte';

	const { Story } = defineMeta({
		title: 'Components/Layout/Sidebar',
		component: Sidebar,
		tags: ['autodocs'],
		args: {
			gap: '1.25rem',
			side: 'left',
			sidebarWidth: '18rem',
			contentMin: '22rem'
		},
		argTypes: {
			gap: { control: { type: 'text' } },
			side: { control: { type: 'select' }, options: ['left', 'right'] },
			sidebarWidth: { control: { type: 'text' } },
			contentMin: { control: { type: 'text' } }
		}
	});
</script>

<Story name="Left Sidebar">
	<aside class="panel">
		<h4>Filters</h4>
		<ul>
			<li>Category</li>
			<li>Price</li>
			<li>Tags</li>
		</ul>
	</aside>
	<article class="content">
		<p>This area expands and collapses responsively next to the sidebar.</p>
	</article>
</Story>

<Story name="Right Sidebar" args={{ side: 'right' }}>
	<aside class="panel">
		<h4>Activity</h4>
		<p>Recent events and updates live here.</p>
	</aside>
	<article class="content">
		<p>Primary content comes first in DOM order when the sidebar moves right.</p>
	</article>
</Story>

<style>
	.panel {
		background: color-mix(in srgb, var(--storybook-background) 70%, #000);
		padding: 1rem;
		border-radius: 0.75rem;
		display: grid;
		gap: 0.5rem;
	}

	.content {
		padding: 1rem;
		border-radius: 0.75rem;
		background: color-mix(in srgb, var(--storybook-background) 55%, #000);
	}

	ul {
		margin: 0;
		padding-left: 1rem;
		display: grid;
		gap: 0.25rem;
	}
</style>

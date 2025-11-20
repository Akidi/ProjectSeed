import { render, fireEvent } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import Tabs from './Tabs.svelte';

const items = [
	{ id: 'one', label: 'One', panel: 'First' },
	{ id: 'two', label: 'Two', panel: 'Second' }
];

describe('Tabs', () => {
	it('switches tabs on click', async () => {
		const { getByText, queryByText } = render(Tabs, { props: { items } });
		expect(getByText('First')).toBeTruthy();
		await fireEvent.click(getByText('Two'));
		expect(getByText('Second')).toBeTruthy();
		expect(queryByText('First')).toBeNull();
	});
});

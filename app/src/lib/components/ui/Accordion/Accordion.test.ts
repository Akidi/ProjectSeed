import { render, fireEvent } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import Accordion from './Accordion.svelte';

const items = [
	{ id: 'a', title: 'A', content: 'A body' },
	{ id: 'b', title: 'B', content: 'B body' }
];

describe('Accordion', () => {
	it('toggles panels', async () => {
		const { getByText, queryByText } = render(Accordion, { props: { items } });
		expect(queryByText('A body')).toBeNull();
		await fireEvent.click(getByText('A'));
		expect(getByText('A body')).toBeTruthy();
	});
});

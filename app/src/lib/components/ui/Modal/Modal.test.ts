import { render } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import Modal from './Modal.svelte';

describe('Modal', () => {
	it('renders when open', () => {
		const { getByText } = render(Modal as any, {
			props: { open: true, title: 'Title' },
			slots: { children: 'Body' }
		});
		expect(getByText('Body')).toBeTruthy();
	});
});

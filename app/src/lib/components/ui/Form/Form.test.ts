import { render } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import Field from './Field.svelte';
import Input from './Input.svelte';

describe('Form Field', () => {
	it('shows label and hint', () => {
		const { getByText, getByPlaceholderText } = render(Field as any, {
			props: {
				label: 'Email',
				hint: 'We will not spam you'
			},
			slots: {
				// simple markup slot to avoid component instantiation issues
				default: `<input placeholder="test" />`
			}
		});
		expect(getByText('Email')).toBeTruthy();
		expect(getByText('We will not spam you')).toBeTruthy();
		expect(getByPlaceholderText('test')).toBeTruthy();
	});
});

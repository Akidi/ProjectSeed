import { render } from '@testing-library/svelte';
import { describe, expect, it } from 'vitest';
import Stack from './Stack.svelte';

describe('Stack layout', () => {
	it('renders provided children in order', () => {
		const { getByText } = render(Stack, {
			slots: {
				default: '<p>First</p><p>Second</p>'
			}
		} as any);

		expect(getByText('First')).toBeTruthy();
		expect(getByText('Second')).toBeTruthy();
	});

	it('applies custom gap via CSS variable', () => {
		const { container } = render(Stack, {
			props: { gap: '2.5rem' }
		});

		const root = container.firstElementChild as HTMLElement;
		expect(root.style.getPropertyValue('--stack-gap')).toBe('2.5rem');
	});
});

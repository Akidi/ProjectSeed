import { render } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import Button from './Button.svelte';

describe('Button', () => {
	it('renders label', () => {
		const { getByText } = render(Button as any, { slots: { default: 'Press' } });
		expect(getByText('Press')).toBeTruthy();
	});

	it('respects variant', () => {
		const { container } = render(Button as any, {
			props: { variant: 'secondary' },
			slots: { default: 'Okay' }
		});
		const button = container.querySelector('button');
		expect(button?.className).toContain('ui-button--secondary');
	});
});

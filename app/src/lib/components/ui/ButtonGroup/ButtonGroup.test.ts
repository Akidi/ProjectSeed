import { render } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import ButtonGroup from './ButtonGroup.svelte';
import Button from '../Button/Button.svelte';

describe('ButtonGroup', () => {
	it('renders children', () => {
		const { getByText } = render(ButtonGroup as any, {
			slots: {
				default: `<button>Inside</button>`
			}
		});
		expect(getByText('Inside')).toBeTruthy();
	});
});

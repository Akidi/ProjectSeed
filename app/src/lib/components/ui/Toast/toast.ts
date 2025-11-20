import { addToast } from './store';
import type { ToastItem, ToastVariant } from './store';

type Options = Omit<ToastItem, 'id' | 'variant'> & { variant?: ToastVariant };

export function toast(options: Options) {
	return addToast(options);
}

export const toastSuccess = (description: string, title = 'Success') =>
	toast({ description, title, variant: 'success' });

export const toastError = (description: string, title = 'Error') =>
	toast({ description, title, variant: 'error' });

export const toastWarning = (description: string, title = 'Warning') =>
	toast({ description, title, variant: 'warning' });

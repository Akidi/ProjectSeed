import { writable } from 'svelte/store';

export type ToastVariant = 'default' | 'success' | 'warning' | 'error';

export type ToastItem = {
	id: string;
	title?: string;
	description?: string;
	variant?: ToastVariant;
	duration?: number;
};

export const toasts = writable<ToastItem[]>([]);

export function addToast(toast: Omit<ToastItem, 'id'>) {
	const id = crypto.randomUUID ? crypto.randomUUID() : Math.random().toString(36).slice(2);
	const item: ToastItem = { id, variant: 'default', duration: 4000, ...toast };
	toasts.update((list) => [...list, item]);
	if (item.duration && item.duration > 0) {
		setTimeout(() => dismissToast(id), item.duration);
	}
	return id;
}

export function dismissToast(id: string) {
	toasts.update((list) => list.filter((t) => t.id !== id));
}

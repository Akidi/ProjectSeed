import type { RequestHandler } from '@sveltejs/kit';

export const GET: RequestHandler = async () => {
	return new Response(
		JSON.stringify({
			status: 'ok',
			uptime: process.uptime()
		}),
		{
			headers: {
				'content-type': 'application/json'
			}
		}
	);
};

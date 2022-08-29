import { csrfToken } from '@rails/ujs';

function getBaseHeaders(init?: RequestInit): Record<string, string> {
    const baseHeaders: Record<string, string> = {
        'Content-Type': 'application/json',
        Accept: 'application/json',
    };

    const token = csrfToken();
    if (token !== null && init?.method && init.method !== 'GET') {
        baseHeaders['X-CSRF-TOKEN'] = token;
    }

    return baseHeaders;
}

export async function safeFetch(
    ...params: Parameters<typeof fetch>
): Promise<any> {
    const [input, init] = params;
    const res = await fetch(input, {
        ...init,
        headers: { ...getBaseHeaders(init), ...init?.headers },
    });
    if (!res.ok && res.status !== 404) {
        throw new Error('Network response not ok: ' + res.status);
    }

    if (init?.method && init.method === 'DELETE') {
        return undefined;
    }

    return await res.json().catch(() => undefined);
}

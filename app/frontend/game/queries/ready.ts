import { safeFetch } from '$game/queries/utils';

export const readyUp = () =>
    safeFetch('/ready_up', { method: 'POST', credentials: 'include' });

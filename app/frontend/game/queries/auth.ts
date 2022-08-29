import { User } from '$game/api/types';
import { safeFetch } from '$game/queries/utils';
import { useQuery } from 'react-query';

export const useAuth = <T>(options?: T) =>
    useQuery('auth', () => safeFetch('/user.json') as Promise<User>, options);

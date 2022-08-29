import { Choice } from '$game/api/types';
import { safeFetch } from '$game/queries/utils';
import { useQuery } from 'react-query';

export const useChoices = () =>
    useQuery(
        'choices',
        () =>
            safeFetch('/current_choices.json') as Promise<{ choices: Choice[] }>
    );

import { Choice, Game } from '$game/api/types';
import { safeFetch } from '$game/queries/utils';
import { useQuery } from 'react-query';

export const useWinner = (game?: Game) =>
    useQuery(
        'winner',
        () => safeFetch(`/brackets/${game!.id}/winner.json`) as Promise<Choice>,
        {
            enabled: !!game?.id,
        }
    );

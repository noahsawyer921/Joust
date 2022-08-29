import { Matchup } from '$game/api/types';
import { safeFetch } from '$game/queries/utils';
import { useQuery } from 'react-query';

type MatchupsInformation = {
    active_round_num: number;
    active_round_id: number;
    matchups: Matchup[];
};

export const useMatchups = () =>
    useQuery(
        'matchups',
        () => safeFetch('/bracket/round') as Promise<MatchupsInformation>,
        {
            staleTime: 0,
            refetchOnWindowFocus: false,
        }
    );

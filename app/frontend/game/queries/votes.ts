import { InitialVote, Matchup, Vote } from '$game/api/types';
import { safeFetch } from '$game/queries/utils';
import { useMutation, useQuery, useQueryClient } from 'react-query';

function getVotesEndpoint(matchup?: Matchup) {
    if (!matchup) return '';

    return `/matchups/${matchup.id}/vote.json`;
}

export function useVotes(matchup?: Matchup, onCreateVote?: () => void) {
    const queryClient = useQueryClient();
    const votesEndpoint = getVotesEndpoint(matchup);

    const { data: vote } = useQuery(
        ['matchup', matchup?.id, 'vote'],
        () => safeFetch(votesEndpoint) as Promise<Vote>,
        {
            enabled: matchup?.id !== undefined,
        }
    );

    const createVote = useMutation(
        (vote: InitialVote) =>
            safeFetch(votesEndpoint, {
                method: 'POST',
                body: JSON.stringify(vote),
            }) as Promise<Vote>,
        {
            onSuccess() {
                queryClient.invalidateQueries('votes');
                onCreateVote?.();
            },
        }
    );

    return { vote, createVote };
}

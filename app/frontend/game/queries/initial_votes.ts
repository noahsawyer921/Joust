import { Choice, InitialVote } from '$game/api/types';
import { safeFetch } from '$game/queries/utils';
import { useMemo } from 'react';
import { useMutation, useQuery, useQueryClient } from 'react-query';

const initialVotesQueryName = 'initial_votes';
const votesEndpoint = '/current_initial_votes.json';
const createVoteEndpoint = '/initial_vote_for_session.json';
const deleteVoteEndpoint = '/initial_votes';

export function useInitialVotes() {
    const queryClient = useQueryClient();

    const { data: votesData } = useQuery(
        initialVotesQueryName,
        () =>
            safeFetch(votesEndpoint) as Promise<{
                initial_votes: InitialVote[];
            }>
    );

    const votes = votesData?.initial_votes;

    const voteSet = useMemo(
        () => new Set(votes?.map(vote => vote.choice_id) || []),
        [votes]
    );

    const createVote = useMutation(
        (vote: InitialVote) =>
            safeFetch(createVoteEndpoint, {
                method: 'POST',
                body: JSON.stringify(vote),
            }) as Promise<InitialVote>,
        {
            onSuccess() {
                queryClient.invalidateQueries(initialVotesQueryName);
            },
        }
    );
    const deleteVote = useMutation(
        (vote: InitialVote) =>
            safeFetch(`${deleteVoteEndpoint}/${vote.id}.json`, {
                method: 'DELETE',
                body: JSON.stringify(vote),
            }),
        {
            onSuccess() {
                queryClient.invalidateQueries(initialVotesQueryName);
            },
        }
    );

    const toggleVote = (choice: Choice, vote: InitialVote) =>
        (voteSet.has(choice.id) ? deleteVote : createVote).mutate(vote);

    return { votes, voteSet, toggleVote };
}

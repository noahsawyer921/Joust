import { Game, Message, MessageType } from '$game/api/types';
import { createGameConsumer } from '$game/channels/game';
import { useConsumer } from '$game/channels/hooks';
import { safeFetch } from '$game/queries/utils';
import { useQuery, useQueryClient } from 'react-query';

export const useGame = () => {
    const queryClient = useQueryClient();
    const query = useQuery(
        'game',
        () => safeFetch('/bracket.json') as Promise<Game>,
        {
            structuralSharing: false,
        }
    );

    useConsumer(
        'game',
        () =>
            createGameConsumer(query.data!.code, {
                received(data) {
                    const message = data as Message;

                    queryClient.setQueryData(
                        'game',
                        (oldData: Game | undefined) => {
                            const game = oldData!;
                            switch (message.type) {
                                case MessageType.PlayersReady:
                                    game.ready_users = message.players_ready;
                                    break;
                                case MessageType.GameState:
                                    game.state = message.game_state;
                                    break;
                                case MessageType.RoundChange:
                                    game.round = message.round;
                                    break;
                                default:
                                    break;
                            }
                            return { ...game };
                        }
                    );
                },
            }),
        { enabled: !!query.data?.code }
    );

    return query;
};

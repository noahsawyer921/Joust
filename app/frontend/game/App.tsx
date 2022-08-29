import { GameState } from '$game/api/types';
import { useAuth } from '$game/queries/auth';
import { useGame } from '$game/queries/game';
import { FC, useEffect } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';

function getGamePath(gameState: GameState, round: number): string {
    switch (gameState) {
        case GameState.VOTING:
            return '/voting';
        case GameState.MATCHUP:
            return `/round/${round + 1}`;
        case GameState.FINISH:
            return '/finish';
        default:
            return '/waiting';
    }
}

const App: FC = () => {
    const { isError: isAuthError, isLoading: isAuthLoading } = useAuth({
        retry: false,
    });
    const {
        isError: isGameError,
        isLoading: isGameLoading,
        data: game,
    } = useGame();

    const isError = isAuthError || isGameError;
    const isLoading = isAuthLoading || isGameLoading;

    const navigate = useNavigate();

    useEffect(() => {
        if (!game) return;

        navigate(getGamePath(game.state, game.round), { replace: true });
    }, [game?.state, game?.round]);

    if (isError) {
        window.location.replace('/');
    }

    if (isLoading) {
        return <main></main>;
    }

    return <Outlet />;
};

export default App;

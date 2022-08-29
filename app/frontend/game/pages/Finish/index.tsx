import { useGame } from '$game/queries/game';
import { FC } from 'react';

import { useWinner } from '$game/queries/winner';
import { csrfToken } from '@rails/ujs';
import winnerBackground from '$game/assets/images/winner-background.png';
import jLookingDown from '$game/assets/images/j-looking-down.svg';
import styles from './styles.module.css';
import LeaveButton from '$game/components/navigation/LeaveButton';

const Finish: FC = () => {
    const { data: game } = useGame();
    const { data: winner } = useWinner(game);

    const handleExit = async () => {
        await fetch('/leave', {
            method: 'POST',
            credentials: 'include',
            body: JSON.stringify({
                _method: 'delete',
                authenticity_token: csrfToken(),
            }),
        });
        window.location.replace('/');
    };

    return (
        <main className={styles.wrapper}>
            <h1 className={styles.title}>Winner!</h1>
            <div className={styles.winner}>
                <img
                    src={winnerBackground}
                    alt=""
                    className={styles.blob}
                    draggable="false"
                />
                <h2>{winner?.label}</h2>
                <p>{winner?.user?.name || ''}</p>
            </div>
            <div className={styles.buttonRow}>
                <LeaveButton>Exit</LeaveButton>
                <div style={{ position: 'relative' }}>
                    <img src={jLookingDown} alt="" className={styles.jButton} />
                    {/* Both buttons do the same thing for now... */}
                    <LeaveButton className="small">Again</LeaveButton>
                </div>
            </div>
        </main>
    );
};

export default Finish;

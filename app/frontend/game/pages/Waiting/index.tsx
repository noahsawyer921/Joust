import { useGame } from '$game/queries/game';
import { FC } from 'react';
import jDancing from '$game/assets/animations/jDancing.json';
import waitingBlue from '$game/assets/images/waiting-blue.svg';
import Lottie from 'lottie-react';

import styles from './styles.module.css';
import { useAuth } from '$game/queries/auth';
import { isAdmin } from '$game/api/helpers';
import { safeFetch } from '$game/queries/utils';

const Waiting: FC = () => {
    const { data: user } = useAuth();
    const { data: game } = useGame();

    const { ready_users, users } = game!;

    const override = () =>
        safeFetch(`/brackets/${game?.id}/next`, { method: 'PATCH' });

    return (
        <main className={styles.wrapper}>
            <div
                className={`logo-wrapper ${styles.columnChild} ${styles.logoWrapperOverride}`}
            >
                <Lottie
                    animationData={jDancing}
                    loop={true}
                    className={styles.jDancing}
                    role="presentation"
                />
                <p className="label simple">Waiting...</p>
                <img
                    src={waitingBlue}
                    alt=""
                    className={styles.blob}
                    draggable="false"
                />
            </div>
            <div className={styles.columnChild}>
                <p className="message">
                    {ready_users}/{users.length} Ready
                </p>
                {isAdmin(user!, game!) && (
                    <button
                        className="secondary small navigation"
                        onClick={override}
                    >
                        Override
                    </button>
                )}
            </div>
        </main>
    );
};

export default Waiting;

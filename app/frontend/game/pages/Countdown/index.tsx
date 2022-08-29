import DelayedNavigate from '$game/components/navigation/DelayedNavigate';
import { FC, useEffect, useRef, useState } from 'react';
import converter from 'number-to-words';

import styles from './styles.module.css';
import { useLocation } from 'react-router-dom';
import { useMatchups } from '$game/queries/matchups';

type CountdownLocationState = {
    variant?: 'standard' | 'final';
};

const Countdown: FC = () => {
    const [countdown, setCountdown] = useState(3);
    const { data: matchups } = useMatchups();
    const intervalRef = useRef<number>();
    const location = useLocation();
    const variant =
        (location.state as CountdownLocationState)?.variant ?? 'standard';

    const goText = variant === 'standard' ? 'Joust!' : 'Final<br> Round!';

    useEffect(() => {
        intervalRef.current = setInterval(
            () => setCountdown(cur => cur - 1),
            1000
        ) as unknown as number;

        return () => clearInterval(intervalRef.current);
    }, []);

    return (
        <main
            className={`${styles.background} ${
                styles[converter.toWords(countdown)]
            } ${styles[variant]}`}
        >
            <h1
                className={`${styles.countdown} ${
                    countdown === 0 ? styles.joust : ''
                }`}
                dangerouslySetInnerHTML={{
                    __html: (countdown || goText).toString(),
                }}
            ></h1>
            <DelayedNavigate
                route={`/matchups/${matchups?.matchups[0].id}`}
                delay={3999}
                hidden
            />
        </main>
    );
};

export default Countdown;

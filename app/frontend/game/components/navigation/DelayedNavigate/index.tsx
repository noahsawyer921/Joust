import { FC, useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import styles from './styles.module.css';

type DelayedNavigateProps = {
    route: string;
    delay: number;
    hidden?: boolean;
    routeProps?: any;
};

const DelayedNavigate: FC<DelayedNavigateProps> = ({
    route,
    routeProps,
    delay,
    hidden = false,
}) => {
    const intervalRef = useRef<number>();
    const start = useRef<number>();

    const navigate = useNavigate();

    const [duration, setDuration] = useState(0);

    useEffect(() => {
        start.current = performance.now();

        intervalRef.current = setInterval(() => {
            const duration =
                performance.now() - (start.current || performance.now());
            setDuration(duration);
            if (duration >= delay) {
                navigate(route, { replace: true, state: routeProps });
            }
        }, 100) as unknown as number;

        return () => clearInterval(intervalRef.current);
    }, [route, delay, routeProps]);

    if (hidden) {
        return null;
    }

    return (
        <div className={styles.progressWrapper}>
            <svg
                className={styles.progress}
                viewBox="0 0 70 70"
                aria-hidden="true"
            >
                <path
                    d="M 35 0 A 35 35 0 0 1 70 35 A 35 35 0 0 1 35 70 A 35 35 0 0 1 0 35 A 35 35 0 0 1 35 0"
                    strokeWidth="8"
                    stroke="var(--primary)"
                    fill="none"
                    style={{
                        animation: `${styles.progressAnimation} ${delay}ms linear 1 both`,
                    }}
                />
            </svg>
            <progress
                max={delay}
                value={duration}
                className="sr-only"
            ></progress>
            <p>{Math.ceil((delay - duration) / 1000)}</p>
        </div>
    );
};

export default DelayedNavigate;

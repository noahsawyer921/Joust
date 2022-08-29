import { Choice } from '$game/api/types';
import { FC } from 'react';
import styles from './styles.module.css';

type ChoiceButtonProps = {
    choice: Choice;
    variant: 'blue' | 'yellow' | 'green' | 'pink';
    onClick: () => void;
};

const ChoiceButton: FC<ChoiceButtonProps> = ({ choice, variant, onClick }) => {
    return (
        <article>
            <button
                className={`${styles.button} ${styles[variant]}`}
                onClick={onClick}
            >
                <svg className={`${styles.blob}  ${styles[variant]}`}>
                    <path
                        d="M27.1504 0.886731C17.3343 -0.256884 8.61396 7.17847 8.19146 17.0519L0.266863 202.243C0.14248 205.149 0.658843 208.048 1.77936 210.733L2.19628 211.732C12.1855 235.667 34.0527 252.563 59.7339 256.19L229.548 280.171C242.755 282.036 254.397 271.419 253.753 258.096L243.879 53.5876C243.11 37.6607 230.931 24.6282 215.093 22.7829L27.1504 0.886731Z"
                        stroke="none"
                    />
                </svg>
                <svg className={styles.border}>
                    <path
                        d="M54.3847 3.16573C46.224 1.05313 37.9873 6.31741 36.4774 14.6108L3.27451 196.973C2.81904 199.475 2.91928 202.046 3.56814 204.504L3.84437 205.551C10.2376 229.775 28.9275 248.835 53.0218 255.701L217.954 302.704C229.272 305.93 240.731 298.056 241.778 286.333L259.994 82.3981C261.304 67.7341 251.813 54.275 237.56 50.5853L54.3847 3.16573Z"
                        fill="none"
                        strokeWidth="5"
                    />
                </svg>
                <section>
                    <h2>{choice.label}</h2>
                    <p>{choice.reasoning}</p>
                </section>
            </button>
        </article>
    );
};

export default ChoiceButton;

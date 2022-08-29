import { Choice } from '$game/api/types';
import { FC } from 'react';
import styles from './styles.module.css';
import pink from '$game/assets/images/matchup/pink.svg';
import orange from '$game/assets/images/matchup/orange.svg';
import yellow from '$game/assets/images/matchup/yellow.svg';
import blue from '$game/assets/images/matchup/blue.svg';
import orangeFinalFour from '$game/assets/images/matchup/orange-final-four.png';
import yellowFinalFour from '$game/assets/images/matchup/yellow-final-four.png';
import yellowFinal from '$game/assets/images/matchup/yellow-final.png';

const blobs = {
    pink,
    orange,
    yellow,
    blue,
    orangeFinalFour,
    yellowFinalFour,
    yellowFinal,
};

export type MatchupStyleVariant = keyof typeof blobs;

type MatchupProps = {
    first: Choice;
    second: Choice;
    variant: MatchupStyleVariant;
};

const Matchup: FC<MatchupProps> = ({ first, second, variant }) => {
    const getVariantType = (variant: MatchupStyleVariant) => {
        if (variant === 'orangeFinalFour' || variant === 'yellowFinalFour') {
            return 'finalFour';
        } else if (variant === 'yellowFinal') {
            return 'final';
        }
        return '';
    };

    return (
        <article
            className={`${styles.matchup} ${styles[getVariantType(variant)]}`}
        >
            <img
                src={blobs[variant]}
                alt=""
                className={`${styles[getVariantType(variant)]} ${styles.blob} ${
                    styles[variant]
                }`}
            />
            <p className={styles.choice}>{first.label}</p>
            <p className="label simple">vs</p>
            <p className={styles.choice}>{second.label}</p>
        </article>
    );
};

export default Matchup;

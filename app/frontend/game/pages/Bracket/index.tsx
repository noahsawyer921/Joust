import { FC } from 'react';

import Matchup, { MatchupStyleVariant } from '$game/components/bracket/Matchup';
import DelayedNavigate from '$game/components/navigation/DelayedNavigate';
import { useMatchups } from '$game/queries/matchups';
import converter from 'number-to-words';
import styles from './styles.module.css';

const Bracket: FC = () => {
    const { data: matchupsData } = useMatchups();

    const matchupTitle = matchupsData
        ? matchupsData.matchups.length === 1
            ? 'Final Round!'
            : `Round ${converter.toWords(matchupsData.active_round_num + 1)}!`
        : '';

    const variants = ['pink', 'orange', 'yellow', 'blue'] as const;

    const getMatchupVariant = (index: number): MatchupStyleVariant => {
        const matchups = matchupsData?.matchups.length || 0;

        if (matchups > 2) {
            return variants[index % variants.length];
        } else if (matchups == 2) {
            return index === 0 ? 'orangeFinalFour' : 'yellowFinalFour';
        } else {
            return 'yellowFinal';
        }
    };

    return (
        <div className={styles.wrapper}>
            <p className={`label ${styles.title}`}>{matchupTitle}</p>

            {matchupsData?.matchups.map(
                ({ id, first_choice, second_choice }, i) => (
                    <Matchup
                        key={id}
                        first={first_choice}
                        second={second_choice}
                        variant={getMatchupVariant(i)}
                    />
                )
            )}

            <DelayedNavigate
                route="/countdown"
                routeProps={{
                    variant:
                        matchupsData?.matchups.length === 1
                            ? 'final'
                            : 'standard',
                }}
                delay={10000}
            />
        </div>
    );
};

export default Bracket;

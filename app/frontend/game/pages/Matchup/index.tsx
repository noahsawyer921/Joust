import ChoiceButton from '$game/components/matchup/ChoiceButton';
import { useMatchups } from '$game/queries/matchups';
import { useVotes } from '$game/queries/votes';
import { FC, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import twistUpArrow from '$game/assets/images/twist-up-arrow.svg';
import twistDownArrow from '$game/assets/images/twist-down-arrow.svg';
import styles from './styles.module.css';
import { Choice } from '$game/api/types';
import { readyUp } from '$game/queries/ready';
import { motion } from 'framer-motion';
import { sleep } from '$game/utils';

const firstVariants = {
    up: { y: '-600px', x: '-50px' },
    down: { y: '1000px', x: '200px' },
};

const secondVariants = {
    up: { y: '-1000px', x: '-200px' },
    down: { y: '600px', x: '50px' },
};

const Matchup: FC = () => {
    const { id: idString } = useParams();
    const id = parseInt(idString ?? '');
    const navigate = useNavigate();
    const { data: matchups } = useMatchups();
    const [chosen, setChosen] = useState<Choice>();

    const choiceVariants = ['blue', 'yellow', 'green', 'pink'] as const;

    const currentMatchupIdx =
        matchups?.matchups.findIndex(matchup => matchup.id === id) ?? 0;
    const currentMatchup = matchups?.matchups[currentMatchupIdx];
    const isLastMatchup =
        currentMatchupIdx === (matchups?.matchups.length ?? 0) - 1;
    const firstWon = chosen === currentMatchup?.first_choice;

    const { vote, createVote } = useVotes(
        matchups?.matchups.find(matchup => matchup.id === id),
        async () => {
            if (!isLastMatchup) return;
            await sleep(750);
            readyUp();
            navigate('/waiting', { replace: true });
        }
    );

    useEffect(() => {
        if (vote && !chosen) {
            if (isLastMatchup) {
                navigate('/waiting', { replace: true });
            } else {
                navigate(
                    `/matchups/${matchups?.matchups[currentMatchupIdx + 1].id}`,
                    { replace: true }
                );
            }
        }
    }, [vote, chosen]);

    useEffect(() => {
        setChosen(undefined);
    }, [id]);

    const handleVote = async (choice: Choice) => {
        setChosen(choice);
        createVote.mutate({
            choice_id: choice.id,
        });

        if (!isLastMatchup) {
            await sleep(750);

            navigate(
                `/matchups/${matchups?.matchups[currentMatchupIdx + 1].id}`,
                { replace: true }
            );

            if (document.activeElement && 'blur' in document.activeElement) {
                (document.activeElement as HTMLElement).blur();
            }
        }
    };

    return (
        <main className={styles.wrapper}>
            <h1 className={`label ${styles.title}`}>Choose one!</h1>
            {currentMatchup && (
                <>
                    <motion.div
                        style={{ position: 'relative', right: '100px' }}
                        animate={
                            chosen ? (firstWon ? 'down' : 'up') : undefined
                        }
                        transition={{
                            ease: 'easeInOut',
                            delay: chosen ? (firstWon ? 0.1 : 0) : 0,
                            duration: chosen ? (firstWon ? 0.5 : 0.3) : 0.5,
                        }}
                        variants={firstVariants}
                    >
                        <ChoiceButton
                            choice={currentMatchup.first_choice}
                            variant={
                                choiceVariants[
                                    (currentMatchupIdx * 2) %
                                        choiceVariants.length
                                ]
                            }
                            onClick={() =>
                                handleVote(currentMatchup.first_choice)
                            }
                        />
                    </motion.div>
                    <div className={styles.middle}>
                        <img src={twistUpArrow} alt="" className={styles.up} />
                        <p className="label simple">vs</p>
                        <img
                            src={twistDownArrow}
                            alt=""
                            className={styles.down}
                        />
                    </div>
                    <motion.div
                        style={{ position: 'relative', left: '100px' }}
                        animate={
                            chosen ? (!firstWon ? 'up' : 'down') : undefined
                        }
                        variants={secondVariants}
                        transition={{
                            ease: 'easeInOut',
                            delay: chosen ? (!firstWon ? 0.1 : 0) : 0,
                            duration: chosen ? (!firstWon ? 0.5 : 0.3) : 0.5,
                        }}
                    >
                        <ChoiceButton
                            choice={currentMatchup.second_choice}
                            variant={
                                choiceVariants[
                                    (currentMatchupIdx * 2 + 1) %
                                        choiceVariants.length
                                ]
                            }
                            onClick={() =>
                                handleVote(currentMatchup.second_choice)
                            }
                        />
                    </motion.div>
                </>
            )}
            <div className={styles.progressWrapper}>
                <label
                    htmlFor={`${currentMatchupIdx}-progress`}
                    className="progress simple"
                >
                    {currentMatchupIdx + 1}/{matchups?.matchups.length}
                </label>
                <progress
                    id={`${currentMatchupIdx}-progress`}
                    max={matchups?.matchups.length}
                    value={currentMatchupIdx + 1}
                    className={styles.progressBar}
                ></progress>
            </div>
        </main>
    );
};

export default Matchup;

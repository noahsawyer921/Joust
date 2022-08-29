import { FC } from 'react';

import votingGreen from '$game/assets/images/voting-green.svg';
import votingOrange from '$game/assets/images/voting-orange.svg';
import { useChoices } from '$game/queries/choices';
import { useInitialVotes } from '$game/queries/initial_votes';
import styles from './styles.module.css';
import { Choice } from '$game/api/types';
import { getChoicesToEliminate } from '$game/api/helpers';
import ReadyLink from '$game/components/navigation/ReadyLink';
import LeaveButton from '$game/components/navigation/LeaveButton';

const Voting: FC = () => {
    const { data: choices, isSuccess } = useChoices();
    const { votes, voteSet, toggleVote } = useInitialVotes();

    const toEliminate = choices?.choices
        ? getChoicesToEliminate(choices.choices.length)
        : 0;

    const handleClick = (choice: Choice) => {
        toggleVote(choice, {
            choice_id: choice.id,
            id: voteSet.has(choice.id)
                ? votes?.find(({ choice_id }) => choice_id === choice.id)?.id
                : undefined,
        });
    };

    return (
        <main className={styles.wrapper}>
            <nav className={styles.center}>
                <LeaveButton>Leave</LeaveButton>
            </nav>
            <div className={styles.voteInfo}>
                <h1>Vote!</h1>
                <p className={`label simple ${styles.voteInfoDescription}`}>
                    Select the options you like. Only the best will make it!
                </p>
                <img src={votingOrange} alt="" className={styles.orangeBlob} />
            </div>

            {isSuccess &&
                choices.choices?.map((choice, i) => (
                    <button
                        key={choice.id}
                        className={`secondary large checkbox ${
                            i % 2 !== 0 ? 'reverse' : ''
                        }`}
                        role="checkbox"
                        aria-checked={voteSet.has(choice.id)}
                        onClick={() => handleClick(choice)}
                    >
                        <span>{choice.label}</span>
                    </button>
                ))}

            <div className="row-wrapper">
                <div className={styles.nextWrapper}>
                    <ReadyLink
                        to="/waiting"
                        className="button small navigation"
                        replace
                    >
                        Next
                    </ReadyLink>
                    <img src={votingGreen} alt="" className={styles.blob} />
                </div>
            </div>
        </main>
    );
};

export default Voting;

import { csrfToken } from '@rails/ujs';
import { FC, PropsWithChildren } from 'react';

type LeaveButtonProps = PropsWithChildren & {
    className?: string;
};

const LeaveButton: FC<LeaveButtonProps> = ({
    children,
    className = 'secondary small navigation',
}) => {
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
        <button className={className} onClick={handleExit}>
            {children}
        </button>
    );
};

export default LeaveButton;

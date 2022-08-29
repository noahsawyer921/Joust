import { readyUp } from '$game/queries/ready';
import { FC } from 'react';
import { Link, LinkProps } from 'react-router-dom';

type ReadyLinkProps = LinkProps;

const ReadyLink: FC<ReadyLinkProps> = ({ ...props }) => {
    return <Link {...props} onClick={readyUp} />;
};

export default ReadyLink;

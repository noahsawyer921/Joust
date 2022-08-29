import { ACTION_CABLE_URL } from '$game/api/urls';
import { Consumer, createConsumer, Mixin } from '@rails/actioncable';

const GAME_CHANNEL = 'GameChannel';

export function createGameConsumer(code: string, mixin: Mixin): Consumer {
    const consumer = createConsumer(ACTION_CABLE_URL);

    consumer.subscriptions.create({ channel: GAME_CHANNEL, code }, mixin);

    return consumer;
}

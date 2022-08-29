import { Consumer } from '@rails/actioncable';

const consumers: Record<string, Consumer> = {};

type UseConsumerOptions = {
    enabled?: boolean;
};

const defaultUseConsumerOptions = { enabled: true };

export function useConsumer(
    consumerKey: string,
    createConsumer: () => Consumer,
    options: UseConsumerOptions = defaultUseConsumerOptions
): Consumer | undefined {
    if (!options.enabled) return;

    if (consumers[consumerKey]) return consumers[consumerKey];

    return (consumers[consumerKey] = createConsumer());
}

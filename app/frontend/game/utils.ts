export const dev = import.meta.env.DEV;

export function sleep(millis: number) {
    return new Promise(resolve => setTimeout(resolve, millis));
}

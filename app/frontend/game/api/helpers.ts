import { Game, User } from '$game/api/types';

export function isAdmin(user: User, game: Game): boolean {
    return user.id === game.admin_id;
}

export function getChoicesToEliminate(choices: number): number {
    let nearestSmallerP2 = 1;

    while (nearestSmallerP2 <= choices) {
        nearestSmallerP2 <<= 1;
    }

    nearestSmallerP2 >>= 1;

    return choices - nearestSmallerP2;
}

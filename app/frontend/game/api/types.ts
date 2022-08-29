export type User = {
    id: number;
    name: string;
};

export const enum GameState {
    UNINITIALIZED = -1,
    USERS,
    CHOICES,
    VOTING,
    MATCHUP,
    FINISH,
}

export type Choice = {
    id: number;
    label: string;
    reasoning: string;
    user?: User;
};

export type Vote = {
    id?: number;
    matchup_id: number;
    choice_id: number;
    user_id: number;
};

export type InitialVote = {
    id?: number;
    choice_id: number;
};

export type Matchup = {
    id: number;
    first_choice: Choice;
    first_choice_votes: number;
    second_choice: Choice;
    second_choice_votes: number;
};

export type Round = {
    matchups: Matchup[];
};

export type Bracket = {
    id: number;
    round: Round[];
};

export type Game = {
    id: number;
    admin_id: number;
    code: string;
    users: User[];
    ready_users: number;
    round: number;
    state: GameState;
};

export const enum MessageType {
    PlayersReady,
    GameState,
    RoundChange,
}

export type PlayersReadyMessage = {
    type: MessageType.PlayersReady;
    players_ready: number;
};

export type GameStateMessage = {
    type: MessageType.GameState;
    game_state: GameState;
};

export type RoundChangeMessage = {
    type: MessageType.RoundChange;
    round: number;
};

export type Message =
    | PlayersReadyMessage
    | GameStateMessage
    | RoundChangeMessage;

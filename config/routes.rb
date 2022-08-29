Rails.application.routes.draw do
  resources :readies
  resources :initial_votes
  resources :users
  resources :votes
  resources :choices
  resources :matchups do
    get "/vote", to: "matchups#get_matchup_current_vote"
    post "/vote", to: "matchups#session_vote_on_matchup"
  end
  resources :rounds
  #get "rounds/index/:bracket_id", to: "rounds#filteredjson"
  resources :brackets do
    patch "/next", to: "brackets#activate_next_round"
    get "/waiting_users", to: "brackets#show_users"
    get "/waiting_ideas", to: "brackets#show_ideas"
    get "/start_game", to: "brackets#start_game"
    patch "/move_to_choices", to: "brackets#move_to_choices"
    get "/winner", to: "brackets#display_winner"
  end
  get "/bracket", to: "brackets#game_details"
  get "/current_choices", to: "brackets#choices_for_current_bracket"
  get "/user", to: "brackets#session_details"
  get "/bracket/round", to: "brackets#active_round_matchups"
  get "/rounds/for_bracket/:bracket_id", to: "rounds#rounds_for_bracket"
  get "/join", to: "brackets#join"
  get "/join_with_code", to: "brackets#join_with_code"
  get "/name", to: "users#new"
  get "/game", to: "brackets#game"
  get "/game/*other", to: "brackets#game"
  post "/ready_up", to: "brackets#ready_current_session"
  post "/unready_up", to: "brackets#unready_current_session"
  post "/unready_all", to: "brackets#unready_all"
  get "/current_initial_votes", to: "initial_votes#initial_votes_for_session"
  post "/initial_vote_for_session", to: "initial_votes#create_initial_vote_for_session"
  delete "/initial_votes", to: "initial_votes#destroy"
  delete "/leave", to: "brackets#leave"
  get "/broadcast", to: "brackets#test_cast"
  get "/ready_to_start", to: "brackets#ready_to_start"
  get "/help", to: "brackets#help"


  post "/bracket/matchup", to: "votes#create"
=begin
  Creation post requests for votes should have their data structured as follows
  {
    "vote": {
      "user_id": int
      "choice_id": int
      "matchup_id": int
    }
  }
=end
  root "brackets#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

json.id session[:current_bracket_id]
json.code @bracket.code
json.users @bracket.users do |user|
	json.id user.id
	json.name user.name
end
json.ready_users ready_users
json.admin_id @bracket.admin_id
json.round active_round ? active_round.round_num : -1
json.state @bracket.game_state
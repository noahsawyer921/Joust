json.active_round_num active_round_for_bracket(session[:current_bracket_id]).round_num
json.active_round_id active_round_for_bracket(session[:current_bracket_id]).id
json.matchups active_round_for_bracket(session[:current_bracket_id]).matchups do |matchup|
	json.id matchup.id
	json.first_choice do
		choice = matchup.first_choice
		json.id choice.id
		json.label choice.label
		json.reasoning choice.reasoning
	end
	first_choice_votes = Vote.where(matchup_id: matchup.id, choice_id: matchup.first_choice_id)
	json.first_choice_votes first_choice_votes.count
	json.second_choice do
		choice = matchup.second_choice
		json.id choice.id
		json.label choice.label
		json.reasoning choice.reasoning
	end
	second_choice_votes = Vote.where(matchup_id: matchup.id, choice_id: matchup.second_choice_id)
	json.second_choice_votes second_choice_votes.count
end
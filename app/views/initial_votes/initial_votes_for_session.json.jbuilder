initial_votes = InitialVote.where(user_id: session[:current_user_id], bracket_id: session[:current_bracket_id])
json.initial_votes initial_votes.each do |initial_vote|
	json.id initial_vote.id
	json.choice_id initial_vote.choice_id
	#json.user_id initial_vote.user_id
	#json.bracket_id initial_vote.bracket_id
end
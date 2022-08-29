json.choices @bracket.choices do |choice|
	json.id choice.id
	json.label choice.label
	json.reasoning choice.reasoning
	json.user_id choice.user_id
	json.bracket_id choice.bracket_id
end

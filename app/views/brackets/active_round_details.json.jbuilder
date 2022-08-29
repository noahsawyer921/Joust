json.bracket_id session[:current_bracket_id]
json.active_round_num active_round_for_bracket(session[:current_bracket_id]).round_num
json.active_round_id active_round_for_bracket(session[:current_bracket_id]).id
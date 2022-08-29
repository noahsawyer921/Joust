json.id session[:current_user_id]
json.name User.find_by(id: session[:current_user_id]).name
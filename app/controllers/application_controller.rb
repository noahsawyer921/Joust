class ApplicationController < ActionController::Base
	#skip_before_action :verify_authenticity_token

	def logged_in?
		session[:current_user_id] != nil
	end
	helper_method :logged_in?
	def in_game?
		session[:current_bracket_id] != nil
	end
	helper_method :in_game?
	def current_bracket
		Bracket.find_by(id: session[:current_bracket_id])
	end
	helper_method :current_bracket
	def current_user
		User.find_by(id: session[:current_user_id])
	end
	helper_method :current_user

	def connect_bracket_with_user(bracket_id, user_id)
	    user = User.find_by(id: user_id)
	    bracket = Bracket.find_by(id: bracket_id)
	    if bracket.admin_id == nil
	    	bracket.admin_id = user_id
	    	bracket.game_state = 0
	    	bracket.save
	    end
	    if !bracket.users.include?(user)
	    	bracket.users << user
	    end
	    if !user.brackets.include?(bracket)
	    	user.brackets << bracket
	    end
    end
    helper_method :connect_with_user
    def is_admin?(bracket_id, user_id)
    	if Bracket.find_by(id: bracket_id).nil?
    		puts "Bracket does not exist"
    		return nil
    	end
    	user_id == Bracket.find_by(id: bracket_id).admin_id
    end
    helper_method :is_admin?
    def session_is_admin?(bracket_id)
    	if Bracket.find_by(id: bracket_id).nil?
    		puts "Bracket does not exist"
    		return nil
    	end
    	(session[:current_user_id] == Bracket.find_by(id: bracket_id).admin.id) and !session[:current_user_id].nil? and !session[:current_bracket_id].nil? 
    end
    helper_method :session_is_admin?
end

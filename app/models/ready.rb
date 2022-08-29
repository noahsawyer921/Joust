class Ready < ApplicationRecord
	belongs_to :ready_bracket, class_name: "Bracket", foreign_key: "ready_bracket_id"
	belongs_to :ready_user, class_name: "User", foreign_key: "ready_user_id"
end

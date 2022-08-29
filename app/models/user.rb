class User < ApplicationRecord
	has_many :votes, dependent: :destroy
	has_many :choices, dependent: :destroy
	has_and_belongs_to_many :brackets
	has_many :admin_brackets, class_name: "Bracket", foreign_key: "admin_id"
	has_many :readies, foreign_key: :ready_user_id
	has_many :ready_brackets, class_name: "Bracket", through: :readies, source: :ready_user, dependent: :destroy
end

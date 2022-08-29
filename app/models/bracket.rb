class Bracket < ApplicationRecord
	has_many :rounds, dependent: :destroy
	has_many :choices, dependent: :destroy
	has_and_belongs_to_many :users
	has_many :initial_votes, dependent: :destroy
	belongs_to :admin, class_name: "User", foreign_key: "admin_id", optional: true
	has_many :readies, foreign_key: :ready_bracket_id
	has_many :ready_users, class_name: "User", through: :readies, source: :ready_user, dependent: :destroy

	STATES = {
		uninitialized: -1,
		users: 0,
		choices: 1,
		voting: 2,
		matchup: 3,
		finish: 4
	}

	BROADCASTS = {
		ready: 0,
		state: 1,
		round: 2
	}
end

class Choice < ApplicationRecord
	has_many :matchups, :class_name => "Matchup", :foreign_key => "first_choice_id"
	has_many :matchups, :class_name => "Matchup", :foreign_key => "second_choice_id"
	has_many :votes, dependent: :destroy
	has_many :initial_votes, dependent: :destroy
	belongs_to :user
	belongs_to :bracket
end

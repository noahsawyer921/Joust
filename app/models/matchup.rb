class Matchup < ApplicationRecord
  belongs_to :round
  belongs_to :first_choice, :class_name => "Choice", :foreign_key => "first_choice_id"
  belongs_to :second_choice, :class_name => "Choice", :foreign_key => "second_choice_id"
  has_many :votes, dependent: :destroy
end

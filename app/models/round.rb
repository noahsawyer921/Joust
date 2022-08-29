class Round < ApplicationRecord
  belongs_to :bracket
  has_many :matchups, dependent: :destroy
end

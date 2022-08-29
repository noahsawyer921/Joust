class Vote < ApplicationRecord
  belongs_to :matchup
  belongs_to :choice
  belongs_to :user
end

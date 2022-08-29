class InitialVote < ApplicationRecord
  belongs_to :user
  belongs_to :choice
  belongs_to :bracket
end

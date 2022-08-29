class AddUserToVotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :votes, :user, index: true, foreign_key: true
  end
end

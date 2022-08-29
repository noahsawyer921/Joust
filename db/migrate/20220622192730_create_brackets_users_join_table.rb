class CreateBracketsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :brackets, :users do |t|
      t.index :bracket_id
      t.index :user_id
    end


  end
end

class ChangeBracketNameToCode < ActiveRecord::Migration[7.0]
  def change
    rename_column :brackets, :name, :code
  end
end

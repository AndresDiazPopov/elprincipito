class AddStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state, :integer, null: false, default: 1
  end
end

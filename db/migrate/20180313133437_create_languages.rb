class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.integer :state, null: false, default: 0
      t.timestamps null: false
    end
  end
end

class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, :null => false
      t.string :provider
      t.string :uid
      t.text :token
      t.text :token_secret

      t.timestamps null: false
    end
    add_index :identities, :user_id
  end
end

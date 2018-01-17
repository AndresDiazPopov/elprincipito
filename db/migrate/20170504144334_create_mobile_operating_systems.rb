class CreateMobileOperatingSystems < ActiveRecord::Migration
  def change
    create_table :mobile_operating_systems do |t|

      t.string :name, null: :false
      t.timestamps null: false
    end
  end
end

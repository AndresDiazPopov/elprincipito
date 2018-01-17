class CreateMobileOperatingSystemVersions < ActiveRecord::Migration
  def change
    create_table :mobile_operating_system_versions do |t|

      t.references :mobile_operating_system, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end

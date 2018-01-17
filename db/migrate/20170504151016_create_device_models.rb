class CreateDeviceModels < ActiveRecord::Migration
  def change
    create_table :device_models do |t|

      t.references :device_manufacturer, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end

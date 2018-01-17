class CreateAppVersions < ActiveRecord::Migration
  def change
    create_table :app_versions do |t|
      t.string :name, null: false
      t.references :mobile_operating_system, null: false
      t.timestamp :expired_at, null: true
      t.timestamps null: false
    end

    add_foreign_key :app_versions, :mobile_operating_systems

    reversible do |dir|
      dir.up do
        AppVersion.create_translation_table! expired_message: :text
      end

      dir.down do
        AppVersion.drop_translation_table!
      end
    end

    add_reference :logins, :app_version, index: true

  end
end

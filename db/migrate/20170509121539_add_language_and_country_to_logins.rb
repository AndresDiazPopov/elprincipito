class AddLanguageAndCountryToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :locale_language, :string, null: false, default: 'es'
    add_column :logins, :locale_country, :string, null: false, default: 'ES'
  end
end

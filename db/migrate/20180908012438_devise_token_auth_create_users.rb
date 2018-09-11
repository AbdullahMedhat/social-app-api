class DeviseTokenAuthCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Required
      t.string :provider,  null: false, default: 'email'
      t.string :uid,       null: false, default: ''

      ## Database authenticatable
      t.string :email,              null: false
      t.string :encrypted_password, null: false, default: ''

      ## User Info
      t.boolean :admin,    null: false, default: false
      t.string  :username, null: false, default: ''

      ## Tokens
      t.json :tokens
    end

    add_index :users, :email,             unique: true
    add_index :users, %i[uid provider],   unique: true
  end
end

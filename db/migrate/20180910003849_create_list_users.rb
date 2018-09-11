class CreateListUsers < ActiveRecord::Migration
  def change
    create_table :list_users do |t|
      t.belongs_to :user,    index: true
      t.belongs_to :list,    index: true
      t.timestamps null: false
    end
    add_index :list_users, %i[user_id list_id], unique: true
  end
end

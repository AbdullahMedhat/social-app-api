class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content,      null: false, default: ''
      t.references :user,     null: false
      t.references :card
      t.references :replay

      t.timestamps null: false
    end
    add_index :comments, :card_id
    add_index :comments, :replay_id
    add_index :comments, :user_id
  end
end

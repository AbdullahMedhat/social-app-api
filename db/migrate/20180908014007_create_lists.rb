class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string     :title,   null: false, default: ''
      t.references :user,    null: false
    end
    add_index :lists, :user_id
  end
end

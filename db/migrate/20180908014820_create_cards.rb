class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string     :title,          null: false, default: ''
      t.string     :description,    null: false, default: ''
      t.references :list,           null: false
      t.references :user,           null: false
      t.integer    :comments_count, default: 0
    end
    add_index :cards, :list_id
    add_index :cards, :user_id
  end
end

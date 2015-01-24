class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :description
      t.string :trello_board_id, null: false
      t.string :trello_list_id, null: false
      t.integer :frequency, null: false
      t.integer :frequency_period
      t.boolean :disabled, default: false
      t.datetime :next_run
      t.timestamps null: false
    end

    add_index :cards, :user_id
    add_index :cards, :next_run
  end
end

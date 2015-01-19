class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :title, null: false
      t.text :description
      t.string :trello_board_id, null: false
      t.string :trello_list_id, null: false
      t.integer :frequency, null: false
      t.integer :frequency_period, null: false
      t.boolean :disabled, default: false
      t.timestamps null: false
    end
  end
end

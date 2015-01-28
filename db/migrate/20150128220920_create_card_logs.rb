class CreateCardLogs < ActiveRecord::Migration
  def change
    create_table :card_logs do |t|
      t.integer :card_id, null: false
      t.integer :user_id, null: false
      t.boolean :successful, null: false
      t.text :message
      t.datetime :created_at, null: false
    end

    add_index :card_logs, :card_id
    add_index :card_logs, :user_id
  end
end

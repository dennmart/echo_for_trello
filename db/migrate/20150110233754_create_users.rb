class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :full_name
      t.string :nickname
      t.string :oauth_token
      t.timestamps null: false
    end

    add_index :users, [:provider, :uid]
  end
end

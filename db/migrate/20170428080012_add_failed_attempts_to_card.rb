class AddFailedAttemptsToCard < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :failed_attempts, :integer, default: 0
  end
end

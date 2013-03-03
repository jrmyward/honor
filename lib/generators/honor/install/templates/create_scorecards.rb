class CreateHonorScorecardsMigration < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.integer :user_id
      t.integer :daily
      t.integer :weekly
      t.integer :monthly
      t.integer :yearly
      t.integer :lifetime

      t.timestamps
    end
    add_index :scorecards, :user_id
  end
end

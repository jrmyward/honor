class HonorMigration < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :user_id
      t.integer :value
      t.string :category
      t.text :message

      t.timestamps
    end

    create_table :scorecards do |t|
      t.integer :user_id
      t.integer :daily
      t.integer :weekly
      t.integer :monthly
      t.integer :yearly
      t.integer :lifetime

      t.timestamps
    end
    add_index :points, :user_id
    add_index :scorecards, :user_id
  end
end

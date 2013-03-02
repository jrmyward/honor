class CreateHonorPointsMigration < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :value
      t.string :category
      t.text :message

      t.timestamps
    end
  end
end

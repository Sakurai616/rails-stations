class CreateRankings < ActiveRecord::Migration[7.1]
  def change
    create_table :rankings do |t|
      t.references :movie, null: false, foreign_key: true
      t.integer :reservation_count, null: false
      t.date :date, null: false

      t.timestamps
    end

    add_index :rankings, [:movie_id, :date], unique: true
  end
end

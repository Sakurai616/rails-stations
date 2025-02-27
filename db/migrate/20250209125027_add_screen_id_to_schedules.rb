class AddScreenIdToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_reference :schedules, :screen, null: false, foreign_key: true
  end
end

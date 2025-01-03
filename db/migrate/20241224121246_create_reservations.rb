class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :date, null: false
      t.references :schedule, null: false, foreign_key: true
      t.references :sheet, null: false, foreign_key: true
      t.string :email, null: false, comment: '予約者メールアドレス'
      t.string :name, null: false, comment: '予約者名'

      t.timestamps
    end
    add_index :reservations, %i[date schedule_id sheet_id], unique: true, name: 'index_reservations_on_date_and_ids'
  end
end

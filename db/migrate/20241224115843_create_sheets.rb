class CreateSheets < ActiveRecord::Migration[7.1]
  def change
    create_table :sheets do |t|
      t.integer :column, limit: 4, null: false, comment: '座席の列番号'
      t.string :row, limit: 1, null: false, comment: '座席の行番号'

      t.timestamps
    end
  end
end

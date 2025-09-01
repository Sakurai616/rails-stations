class Movie < ApplicationRecord
  has_many :schedules, dependent: :destroy
  has_many :reservations, through: :schedules
  has_many :rankings, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :name, presence: true, uniqueness: { message: 'タイトルが重複しています。' }
  validates :year, presence: true, length: { maximum: 45 }
  validates :description, presence: true
  validates :image_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: '有効なURLを入力してください。' }
  validates :is_showing, inclusion: { in: [true, false], message: '上映中かどうかを選択してください。' }
end

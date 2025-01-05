class Schedule < ApplicationRecord
  belongs_to :movie
  has_many :reservations
  has_many :sheets

  validates :start_time, presence: true
  validates :end_time, presence: true

  def sheets_for_date(date)
    # 日付に基づいて座席予約情報を取得
    sheet.includes(:reservation).where(reservation: { date: date })
  end

  def name
    "#{movie.name} (#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')})"
  end
end

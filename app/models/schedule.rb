class Schedule < ApplicationRecord
  belongs_to :movie
  belongs_to :screen
  has_many :reservations

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :check_show_time_overlap

  def name
    "#{movie.name} (#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')})"
  end

  def check_show_time_overlap
    return if no_overlapping_schedules?

    errors.add(:base, '入力された上映時間中に他の作品が上映されています')
  end

  private

  def no_overlapping_schedules?
    Schedule.where(screen_id: screen_id) # 同じスクリーンのスケジュールのみ取得
            .where.not(id: id) # 自分自身は除外
            .where('(start_time < ?) AND (end_time > ?)', end_time, start_time)
            .empty? # 重複がない場合は true（エラーなし）
  end

  def overlap?(schedule)
    (start_time < schedule.end_time) && (end_time > schedule.start_time)
  end
end

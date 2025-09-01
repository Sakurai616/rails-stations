class RankingsController < ApplicationController
  def index
    # 最新のランキング日（更新日）を取得
    @latest_date = Ranking.maximum(:date)

    # 最新日付のランキングデータのみ取得
    @rankings = Ranking.joins(:movie)
                       .where(date: @latest_date)
                       .order(reservation_count: :desc)
  end
end

namespace :ranking do
  desc 'Update movie ranking based on reservations'
  task update: :environment do
    # 過去30日間の予約データを集計
    start_date = Date.today - 30

    # 上映中の映画ごとの予約件数を集計
    Movie.where(is_showing: true).find_each do |movie|
      total_reservations = Reservation.joins(schedule: :screen) # 複数の劇場をまたいで集計するためscreenも結合
                                      .where(schedule: { movie_id: movie.id }) # 映画ごとに絞り込み
                                      .where(date: start_date..Date.today)
                                      .count

      # 予約数をランキングテーブルに保存
      Ranking.create!(movie: movie, reservation_count: total_reservations, date: Date.today)
      puts "Ranking updated for #{movie.name} with #{total_reservations} reservations"
    end
  end
end

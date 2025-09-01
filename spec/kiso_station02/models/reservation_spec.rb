require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let!(:theater1) { Theater.create!(name: 'TOHOシネマズ新宿') }
  let!(:theater2) { Theater.create!(name: '109シネマズ川崎') }

  let!(:screen1) { Screen.create!(theater: theater1, number: 1) }
  let!(:screen2) { Screen.create!(theater: theater1, number: 2) }
  let!(:screen3) { Screen.create!(theater: theater2, number: 1) }

  let!(:movie) do
    Movie.create!(
      name: 'インセプション',
      year: 2010,
      description: '夢の中に潜入するスリラー映画。',
      image_url: 'https://example.com/inception.jpg',
      is_showing: true
    )
  end

  let!(:schedule1) { Schedule.create!(movie: movie, screen: screen1, start_time: '10:00', end_time: '12:30') }
  let!(:schedule2) { Schedule.create!(movie: movie, screen: screen3, start_time: '12:00', end_time: '14:30') }

  let!(:sheets) do
    [screen1, screen2, screen3].each do |screen|
      ('A'..'C').each do |row|
        (1..5).each do |column|
          Sheet.create!(row: row, column: column, screen: screen)
        end
      end
    end
  end

  let!(:sheet1) { screen1.sheets.first }

  let!(:user) do
    User.create!(
      name: '田中太郎',
      email: 'tanaka@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  it '映画は複数の劇場で上映されること' do
    # 映画のスケジュールに対して、劇場を取得し、重複を除いてカウント
    # 重複を除いた劇場の数が 1 より大きいことを確認
    expect(movie.schedules.map { |s| s.screen.theater }.uniq.count).to be > 1
  end

  it '劇場によって異なる上映スケジュールが持てること' do
    # 各映画のスケジュールが1つ以上存在することを確認
    expect(movie.schedules.count).to be > 0

    # 映画のすべてのスケジュールに対して、screen.theaterが存在することを確認
    movie.schedules.each do |schedule|
      expect(schedule.screen.theater).to be_present
    end

    # 異なる劇場に関連するスケジュールが存在することを確認
    theater1_schedules = movie.schedules.select { |schedule| schedule.screen.theater == theater1 }
    theater2_schedules = movie.schedules.select { |schedule| schedule.screen.theater == theater2 }

    # 異なる劇場に関連するスケジュールが異なることを確認
    expect(theater1_schedules).not_to eq(theater2_schedules)
  end

  it '劇場ごとに複数スクリーンがあること' do
    expect(theater1.screens.count).to be > 1
  end

  it 'すべての劇場のすべてのスクリーンの座席は同じ配置 (3x5)であること' do
    # 各スクリーンに対して、座席が 3 行 5 列 で作成されているか確認
    Screen.all.each do |screen|
      rows = screen.sheets.pluck(:row).uniq # 各スクリーンの座席の行を取得
      columns = screen.sheets.pluck(:column).uniq # 各スクリーンの座席の列を取得

      # 行が A, B, C の 3 つ、列が 1 から 5 までの 5 つであることを確認
      expect(rows).to match_array(%w[A B C])
      expect(columns).to match_array([1, 2, 3, 4, 5])
    end
  end

  it 'ユーザは予約時に劇場を選択できること' do
    reservation = Reservation.create!(user: user, schedule: schedule1, sheet: sheet1, date: '2025-02-21')
    expect(reservation.schedule.screen.theater).to eq(theater1)
  end

  it 'スクリーン情報はユーザには見せず、内部的に区別されること' do
    # スクリーン情報はユーザには見せないため、public_attributes から除外されることを確認
    expect(schedule1.public_attributes.keys).not_to include('screen_id')

    expect(schedule1.screen).to eq(screen1)
    expect(schedule1.screen.number).to eq(1)
  end

  it '映画館・スクリーン・座席・時間帯がすべて同一の予約は複数存在しないこと' do
    # 最初の予約を作成
    Reservation.create!(user: user, schedule: schedule1, sheet: sheet1, date: '2025-02-21')

    # 重複する予約を試みる
    duplicate_reservation = Reservation.new(user: user, schedule: schedule1, sheet: sheet1, date: '2025-02-21')

    # 重複予約が無効であることを確認
    expect(duplicate_reservation).not_to be_valid
    expect(duplicate_reservation.errors[:base]).to include('その座席はすでに予約済みです。')
  end
end

require 'rails_helper'
require 'rake'

RSpec.describe 'ranking:update' do
  before do
    Rake.application.rake_require('tasks/ranking')
    Rake::Task.define_task(:environment)
  end

  let(:user1) do
    User.create!(name: 'User1', email: 'user1@example.com', password: 'password', password_confirmation: 'password')
  end
  let(:user2) do
    User.create!(name: 'User2', email: 'user2@example.com', password: 'password', password_confirmation: 'password')
  end
  let(:movie1) { Movie.create!(name: '映画A', year: '2024', is_showing: true, description: '映画Aの説明', image_url: 'https://example.com/movie_a.jpg') }
  let(:movie2) { Movie.create!(name: '映画B', year: '2024', is_showing: true, description: '映画Bの説明', image_url: 'https://example.com/movie_b.jpg') }
  let(:theater1) { Theater.create!(name: 'シネマA') }
  let(:theater2) { Theater.create!(name: 'シネマB') }
  let(:screen1) { Screen.create!(theater: theater1, number: 1) }
  let(:screen2) { Screen.create!(theater: theater2, number: 2) }
  let(:schedule1) do
    Schedule.create!(movie: movie1, screen: screen1, start_time: 30.days.ago, end_time: 30.days.ago + 2.hours)
  end
  let(:schedule2) do
    Schedule.create!(movie: movie2, screen: screen2, start_time: 15.days.ago, end_time: 15.days.ago + 2.hours)
  end

  let(:sheet1) { Sheet.create!(screen: screen1, row: 'A', column: 1) }
  let(:sheet2) { Sheet.create!(screen: screen2, row: 'B', column: 2) }

  before do
    # 過去30日間の予約データを作成
    5.times do |i|
      Reservation.create!(
        schedule: schedule1,
        sheet: Sheet.create!(screen: screen1, row: 'A', column: i + 1),
        user: user1,
        email: 'user1@example.com',
        name: 'User1',
        date: 30.days.ago
      )
    end
    10.times do |i|
      Reservation.create!(
        schedule: schedule2,
        sheet: Sheet.create!(screen: screen2, row: 'B', column: i + 1),
        user: user2,
        email: 'user2@example.com',
        name: 'User2',
        date: 15.days.ago
      )
    end
  end

  it '過去30日間のランキングを正しく計算して保存する' do
    expect { Rake::Task['ranking:update'].invoke }
      .to change { Ranking.count }.by(2)

    ranking1 = Ranking.find_by(movie: movie1)
    ranking2 = Ranking.find_by(movie: movie2)

    expect(ranking1.reservation_count).to eq(5)
    expect(ranking2.reservation_count).to eq(10)
  end
end

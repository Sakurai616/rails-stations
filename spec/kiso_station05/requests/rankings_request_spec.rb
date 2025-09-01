require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  let!(:movie1) { Movie.create!(name: '映画A', year: 2021, is_showing: true, description: '説明A', image_url: 'https://example.com/image_a.jpg') }
  let!(:movie2) { Movie.create!(name: '映画B', year: 2021, is_showing: true, description: '説明B', image_url: 'https://example.com/image_b.jpg') }

  let!(:ranking1) { Ranking.create!(movie: movie1, reservation_count: 100, date: Date.today) }
  let!(:ranking2) { Ranking.create!(movie: movie2, reservation_count: 50, date: Date.today) }
  let!(:screen) { Screen.create!(theater: Theater.create!(name: 'シネマシティ'), number: 1) }
  let!(:schedule) do
    Schedule.create!(movie: movie1, screen: screen, start_time: '2025-03-25 10:00:00', end_time: '2025-03-25 12:00:00')
  end
  let!(:sheet) { Sheet.create!(screen: screen, row: 'A', column: 1) }
  let!(:user) do
    User.create!(name: 'John Doe', email: 'john.doe@example.com', password: 'password',
                 password_confirmation: 'password')
  end

  describe 'GET /' do
    it '人気作品ランキングを表示する' do
      get root_path

      # トップページに人気作品ランキングが表示されることを確認
      expect(response).to have_http_status(200)
      expect(response.body).to include(ranking1.movie.name)
      expect(response.body).to include(ranking2.movie.name)
    end
  end

  describe 'GET /movies/:id' do
    it '作品詳細ページを表示する' do
      get movie_path(movie1)

      # 作品詳細ページに遷移できることを確認
      expect(response).to have_http_status(200)
      expect(response.body).to include(movie1.name)
      expect(response.body).to include(movie1.description)
    end
  end

  describe 'GET /movies/:movie_id/schedules/:schedule_id/reservations/new' do
    it '予約ページを表示する' do
      sign_in user

      get new_movie_schedule_reservation_path(movie1, schedule_id: schedule.id, date: Date.today, sheet_id: sheet.id)

      expect(response).to have_http_status(200)
    end
  end
end

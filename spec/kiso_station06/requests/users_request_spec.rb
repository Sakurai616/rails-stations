require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) do
    User.create(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
  end
  let!(:movie) do
    Movie.create!(
      name: 'インセプション',
      year: 2010,
      description: '夢の中に潜入するスリラー映画。',
      image_url: 'https://example.com/inception.jpg',
      is_showing: true
    )
  end
  let!(:theater) { Theater.create!(name: 'TOHOシネマズ新宿') }
  let!(:screen) { Screen.create!(theater: theater, number: 1) }
  let!(:schedule) { Schedule.create!(movie: movie, screen: screen, start_time: '10:00', end_time: '12:30') }
  let!(:sheet) { Sheet.create!(screen: screen, row: 'A', column: 1) }
  let!(:reservation) { Reservation.create(user: user, schedule: schedule, sheet: sheet, date: Date.today) }

  describe 'GET /users/:id' do
    context '予約がある場合' do
      before do
        sign_in user
        get user_path(user)
      end

      it '正常にアクセスできる' do
        expect(response).to have_http_status(200)
      end

      it 'ユーザーの情報が表示される' do
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
      end

      it '予約情報が表示される' do
        expect(response.body).to include(reservation.schedule.movie.name)
        expect(response.body).to include(reservation.schedule.start_time.strftime('%H:%M'))
        expect(response.body).to include(reservation.schedule.end_time.strftime('%H:%M'))
        expect(response.body).to include("#{reservation.sheet.row}列#{reservation.sheet.column}番")
      end
    end

    context '予約がない場合' do
      before do
        sign_in user
        get user_path(user)
      end

      it '正常にアクセスできる' do
        expect(response).to have_http_status(200)
      end

      it 'ユーザーの情報が表示される' do
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
      end

      it '予約がないことが表示される' do
        user.reservations.destroy_all # 予約データを削除しておく
        get user_path(user) # 再度リクエストを送る
        expect(response.body).to include('予約はありません') # ビューに「予約はありません」のメッセージが必要
      end
    end
  end
end

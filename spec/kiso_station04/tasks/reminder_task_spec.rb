require 'rails_helper'
require 'rake'

RSpec.describe 'reminder:send', type: :task do
  before do
    Rake.application.rake_require('tasks/reminder')
    Rake::Task.define_task(:environment) # Railsの環境タスクを定義
  end

  let(:user) do
    User.create!(name: 'John Doe', email: 'john.doe@example.com', password: 'password',
                 password_confirmation: 'password')
  end
  let(:movie) do
    Movie.create!(name: 'シン・エヴァンゲリオン劇場版:||', year: '2021', is_showing: true,
                  description: 'エヴァンゲリオン新劇場版、完結。',
                  image_url: 'https://dummyimage.com/200x300/000/fff&text=シン・エヴァンゲリオン劇場版:||')
  end
  let(:theater) { Theater.create!(name: 'シネマシティ') }
  let(:screen) { Screen.create!(theater: theater, number: 1) }
  let(:schedule) do
    Schedule.create!(movie: movie, screen: screen, start_time: Date.tomorrow.change(hour: 10, min: 0, sec: 0),
                     end_time: Date.tomorrow.change(hour: 12, min: 0, sec: 0))
  end
  let(:sheet) { Sheet.create!(screen: screen, row: 'A', column: 1) }
  let!(:reservation) do
    Reservation.create!(schedule: schedule, sheet: sheet, email: user.email, name: user.name, date: Date.tomorrow,
                        user: user)
  end

  it '翌日に予約があるユーザーにリマインドメールを送信する' do
    expect do
      Rake::Task['reminder:send'].invoke
    end.to change { ActionMailer::Base.deliveries.count }.by(1)

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([user.email])
  end
end

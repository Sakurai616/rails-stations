require 'rails_helper'
require 'whenever'

RSpec.describe 'Whenever schedule' do
  let(:output) { `whenever --load-file config/schedule.rb` }

  it '毎日19:00にreminderタスクをスケジュールする' do
    expect(output).to include('0 19 * * *')
    expect(output).to include('rake reminder:send')
  end
end

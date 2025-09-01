require 'rails_helper'
require 'whenever'

RSpec.describe 'Whenever schedule' do
  let(:output) { `whenever --load-file config/schedule.rb` }

  it '毎日0時にランキングrankingタスクをスケジュールする' do
    expect(output).to include('0 0 * * *')
    expect(output).to include('rake ranking:update')
  end
end

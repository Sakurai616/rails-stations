# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Rails.rootを使用するために必要
require File.expand_path("#{File.dirname(__FILE__)}/environment")

set :tz, 'Asia/Tokyo' # wheneverのタイムゾーンを日本時間に設定
ENV['TZ'] = 'Asia/Tokyo' # Rubyプロセス内のタイムゾーンを日本時間に設定
ENV.each { |k, v| env(k, v) } # 環境変数をセット

# cronの実行環境の設定
set :environment, :development

# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

# 予約の前日19時(日本時間)にメールを送信
every 1.day, at: '7:00 pm' do
  rake 'reminder:send'
end

# 毎日0時に予約ランキングの更新
every 1.day, at: '0:00 am' do
  rake 'ranking:update'
end

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

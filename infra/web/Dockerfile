FROM ruby:3.3.6
RUN apt-get update -qq && apt-get install -y default-mysql-client && apt-get install -y cron
RUN apt-get install --no-install-recommends -y build-essential git libvips pkg-config nodejs npm && npm install n -g && n lts
RUN npm install -g yarn
RUN mkdir /app
WORKDIR /app

# このDockerfileでgemのインストールやyarnによるパッケージのインストールをしていないのは、
# ログインなどの処理を挟む必要があるため。
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /app

# wheneverでcrontab書き込み
RUN bundle exec whenever --update-crontab 

RUN apt-get update -qq && apt-get install -y tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV TZ=Asia/Tokyo

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "cron", "-f"]

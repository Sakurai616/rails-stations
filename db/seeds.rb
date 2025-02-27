# 劇場の作成
theaters = %w[シネマ1 シネマ2 シネマ3].map do |name|
  Theater.find_or_create_by!(name: name)
end

# 各劇場にスクリーンを作成
theaters.each do |theater|
  (1..3).each do |screen_number|
    theater.screens.find_or_create_by!(number: screen_number)
  end
end

# 各スクリーンに座席を作成
Screen.all.each do |screen|
  ('A'..'C').each do |row| # 行（A, B, C）
    (1..5).each do |column| # 列（1, 2, 3, 4, 5）
      screen.sheets.find_or_create_by!(row: row, column: column)
    end
  end
end

# 映画の作成
movies = [
  {
    name: 'シン・エヴァンゲリオン劇場版:||',
    year: 2021,
    description: 'エヴァンゲリオン新劇場版、完結。',
    image_url: 'https://dummyimage.com/200x300/000/fff&text=シン・エヴァンゲリオン劇場版:||',
    is_showing: true
  },
  {
    name: 'シャン・チー／テン・リングス',
    year: 2021,
    description: 'マーベル・シネマティック・ユニバース（MCU）の新たな物語。',
    image_url: 'https://dummyimage.com/200x300/000/fff&text=シャン・チー／テン・リングス',
    is_showing: true
  },
  {
    name: 'シャングリラ', year: 2021,
    description: '日本のアニメーション映画。',
    image_url: 'https://dummyimage.com/200x300/000/fff&text=シャングリラ',
    is_showing: true
  }
].map do |movie|
  Movie.find_or_create_by!(movie)
end

# スケジュールの作成
[
  {
    movie: movies[0],
    screen: Screen.find_by(theater: theaters[0], number: 1),
    start_time: Time.zone.local(2021, 9, 1, 9, 0),
    end_time: Time.zone.local(2021, 9, 1, 11, 0)
  },
  {
    movie: movies[1],
    screen: Screen.find_by(theater: theaters[0], number: 2),
    start_time: Time.zone.local(2021, 9, 1, 9, 0),
    end_time: Time.zone.local(2021, 9, 1, 11, 0)
  },
  {
    movie: movies[2], screen: Screen.find_by(theater: theaters[0], number: 3),
    start_time: Time.zone.local(2021, 9, 1, 9, 0),
    end_time: Time.zone.local(2021, 9, 1, 11, 0)
  }
].each do |schedule|
  Schedule.find_or_create_by!(schedule)
end

# ユーザーの作成
[
  {
    name: '太郎',
    email: 'taro@taro.com',
    password: 'password',
    password_confirmation: 'password'
  },
  {
    name: '次郎',
    email: 'jiro@jiro.com',
    password: 'password',
    password_confirmation: 'password'
  }
].each do |user_attrs|
  user = User.find_or_initialize_by(email: user_attrs[:email])
  user.update!(user_attrs)
end

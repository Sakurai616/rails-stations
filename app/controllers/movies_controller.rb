class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show reservation schedules]

  def index
    @movies = Movie.all
    filter_movies_by_showing
    filter_movies_by_keyword
    set_filter_params
  end

  def show
    @theaters = Theater.all.order(:id)
    @movie = Movie.find(params[:id])

    # 選択した劇場に紐づいたスケジュールを取得
    @selected_theater = find_selected_theater
    @schedules = fetch_schedules(@selected_theater)
  end

  # 選択した劇場に紐づいたスケジュールをJSON形式で取得
  def schedules
    theater = find_theater_by_id(params[:theater_id])

    unless theater
      render json: { error: '劇場が見つかりません' }, status: :not_found
      return
    end

    schedules = fetch_schedules_for_theater(theater)
    render json: schedules
  end

  def reservation
    movie_params = params[:movie] || {}
    schedule_id = movie_params[:schedule_id]
    date = movie_params[:date]

    if schedule_id.blank? || date.blank?
      redirect_to movie_path(@movie), alert: 'スケジュールと日付を選択してください'
      return
    end

    @schedule = Schedule.find(schedule_id)
    @date = date
    @sheets = @schedule.screen.sheets
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to movies_path, alert: '指定された映画が見つかりません。'
  end

  # 映画の上映中フラグで絞り込み
  def filter_movies_by_showing
    return unless params[:is_showing].present? && params[:is_showing] != 'all'

    @movies = @movies.where(is_showing: params[:is_showing] == '1')
  end

  # キーワードで映画を絞り込み
  def filter_movies_by_keyword
    return unless params[:keyword].present?

    keyword = params[:keyword]
    @movies = @movies.where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end

  # フィルタリング用のパラメータをセット
  def set_filter_params
    @is_showing = params[:is_showing] || 'all'
    @keyword = params[:keyword] || ''
  end

  def find_selected_theater
    if params[:theater_id].present?
      Theater.find_by(id: params[:theater_id])
    else
      @theaters.first # 初期選択する劇場
    end
  end

  def fetch_schedules(selected_theater)
    if selected_theater
      @movie.schedules.joins(:screen).where(screens: { theater_id: selected_theater.id })
    else
      []
    end
  end

  def find_theater_by_id(theater_id)
    Theater.find_by(id: theater_id)
  end

  def fetch_schedules_for_theater(theater)
    @movie.schedules.joins(:screen).where(screens: { theater_id: theater.id }).map do |schedule|
      {
        id: schedule.id,
        start_time: schedule.start_time.strftime('%H:%M'),
        end_time: schedule.end_time.strftime('%H:%M'),
        screen_number: schedule.screen.number
      }
    end
  end
end

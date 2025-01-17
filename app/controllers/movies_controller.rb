class MoviesController < ApplicationController
  before_action :set_movie, only: [:reservation]

  def index
    @movies = Movie.all
    filter_movies_by_showing
    filter_movies_by_keyword
    set_filter_params
  end

  def show
    @movie = Movie.find(params[:id])
    @schedules = @movie.schedules # 上映スケジュールリスト
    @dates = (Date.today..Date.today + 7.days).to_a # 1週間先までの日付リスト
  end

  def reservation
    if params[:schedule_id].blank? || params[:date].blank?
      redirect_to movie_path(@movie), alert: 'スケジュールと日付を選択してください'
      return
    end
    @schedule = Schedule.find(params[:schedule_id])
    @date = params[:date]
    @sheets = Sheet.all
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to movies_path, alert: '指定された映画が見つかりません。'
  end

  def filter_movies_by_showing
    return unless params[:is_showing].present? && params[:is_showing] != 'all'

    @movies = @movies.where(is_showing: params[:is_showing] == '1')
  end

  def filter_movies_by_keyword
    return unless params[:keyword].present?

    keyword = params[:keyword]
    @movies = @movies.where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end

  def set_filter_params
    @is_showing = params[:is_showing] || 'all'
    @keyword = params[:keyword] || ''
  end
end

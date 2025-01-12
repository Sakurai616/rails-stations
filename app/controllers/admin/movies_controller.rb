module Admin
  class MoviesController < ApplicationController
    before_action :set_movie, only: %i[show edit update destroy]

    def index
      @movies = Movie.includes(:schedules).all
    end

    def show
      @schedules = @movie.schedules
      @dates = (Date.today..Date.today + 7.days).to_a
    end

    def new
      @movie = Movie.new
    end

    def create
      @movie = Movie.new(movie_params)

      if save_movie
        redirect_to admin_movies_path, notice: '映画が正常に登録されました。'
      else
        render_error
      end
    end

    def edit; end

    def update
      if @movie.update(movie_params)
        redirect_to admin_movies_path, notice: '映画情報を更新しました。'
      else
        flash.now[:alert] = '映画情報の更新に失敗しました。入力内容をご確認ください。'
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @movie.destroy
      redirect_to admin_movies_path, notice: '映画が削除されました。'
    end

    private

    def set_movie
      @movie = Movie.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:name, :year, :description, :image_url, :is_showing)
    end

    def save_movie
      @movie.save
    rescue ActiveRecord::RecordNotUnique
      flash.now[:alert] = 'タイトルが重複しています。'
      false
    rescue StandardError => e
      Rails.logger.error(e.message)
      flash.now[:alert] = '原因不明のエラーが発生しました。'
      false
    end

    def render_error
      flash.now[:alert] ||= '登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end
end

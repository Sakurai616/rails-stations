class Admin::SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show edit update destroy]
  before_action :set_movie, only: %i[new create]

  # スケジュール一覧
  def index
    @schedules = Schedule.includes(:movie).all
  end

  # スケジュール詳細
  def show; end

  # 新規スケジュール作成フォーム
  def new
    @schedule = @movie.schedules.build
  end

  # スケジュール作成
  def create
    @schedule = @movie.schedules.new(schedule_params)
    if @schedule.save
      redirect_to admin_movie_path(@movie), notice: 'スケジュールを作成しました。'
    else
      render :new
    end
  end

  # 編集フォーム
  def edit; end

  # 更新処理
  def update
    if @schedule.update(schedule_params)
      redirect_to admin_schedule_path(@schedule), notice: 'スケジュールを更新しました。'
    else
      render :edit
    end
  end

  # 削除
  def destroy
    @schedule.destroy
    redirect_to admin_schedules_path, notice: 'スケジュールを削除しました。'
  end

  private

  def set_schedule
    @schedule = Schedule.includes(:movie).find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time)
  end
end

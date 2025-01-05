class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(_resource)
    movies_path
  end

  def after_sign_out_path_for(_resource)
    new_user_registration_path
  end

  def respond_with(resource, _opts = {})
    # DBに保存された場合はリダイレクト
    if resource.persisted?
      redirect_to after_sign_in_path_for(resource), status: 302
    else
      super
    end
  end

  private

  def configure_permitted_parameters
    # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end

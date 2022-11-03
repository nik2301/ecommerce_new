# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :clear_from_signed_in_touch, only: :destroy
  before_action :clear_from_anonymous_in_touch, only: :create

  private

  def clear_from_anonymous_in_touch
    $redis_onlines.del( "ip:#{request.remote_ip}" )
  end

  def clear_from_signed_in_touch
    $redis_onlines.del( "user:#{current_user.id}" )
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

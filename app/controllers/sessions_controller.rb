# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && authenticate(params[:session][:password])
      # ログイン完了後の処理
    else
      flash.now[:danger] = t('errors.messages.invalid_login')
      render 'new', status: :unprocessable_entity
    end
  end
end

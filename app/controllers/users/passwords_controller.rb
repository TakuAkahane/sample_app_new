# encoding: utf-8
# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout 'single_column'
  before_action :login_required, except: %i[new create edit update]
  before_aciton :role_required, except: %i[new create edit update]

  # GET /resource/pasword/new
  def new
    super
  end

  # パスワード再設定のフォーム
  # POST /resource/password
  def create
    # エラー時にフラッシュメッセージをだすため、@userを一時的に作成
    @user = User.new(email: params[:user][:email])
    flash.now[:error] = t('msg.error_in_the_input_content') unless @user.valid?(:db_auth)
    super
  end

  # パスワード再設定メール経由のリクエスト
  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    # 移行ユーザの場合、事前に確認メール送信をスキップする設定を行う
    user = User.find_by(id: params.permit(:format)[:format])
    if user.prev_site_password.present?
      user.skip_confirmation!
      user.save!(validate: false)
    end
    super
  end

  # パスワード再設定フォームからのリクエスト
  # PUT /resource/password
  def update
    valid_password_regex = /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]{8,30}\z/
    unless params.require(:user)[:password].match(valid_password_regex) && params.require(:user)[:password_confirmation].match(valid_password_regex)
      flash[:error] = t('msg.error_in_the_input_content')
    end
    super
  end
end

# encoding: utf-8
# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Accessible
  layout 'single_column_no_title'

  # GET /resource/sign_in
  def new
    super
    @user = User.new
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
    # Set a flag to suppress auto sign in
    session[:keep_signed_out] = true
    # セッションに保管しているログイン後のリダイレクト情報をクリアする
    store_location_for(:user, nil)
  end
end

# encoding: utf-8
# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Roleable

  def facebook
    session[:sns_auth] = 'facebook'
    callback_from
  end

  def google_oauth2
    session[:sns_auth] = 'google'
    callback_from
  end

  def linkedin
    session[:sns_auth] = 'linkedin'
    callback_from
  end

  def failure
    super
  end

  def sns_auth
    save_session_sns_registration
    case sns_cert_came_from
    when 'facebook'
      redirect_to user_facebook_omniauth_authorize_url
    when 'google'
      redirect_to user_google_oauth2_omniauth_authorize_url
    else
      redirect_to user_linkedin_omniauth_authorize_url
    end
  end

  protected

    def callback_from
      raise StandardError unless request.env['omniauth.auth'].present?
      @omniauth = request.env['omniauth.auth']
      user = save_user
      if user.terms_of_servise
        flash[:success] = I18n.t('devise.omniauth_callbacks.success', kind: @omniauth.provider.capitalize)
        sign_in_and_redirect user, event: :authentication
        return
      end
      # SNS認証のみだけで、必要な情報がない（利用規約承諾で確認）場合、プロフィール編集へリダイレクト
      sign_in :user, user
      redirect_to edit_user_registration_path
      clear_session_sns_registration
    end

    def save_user
      user = current_user
      begin
        ActiveRecord::Base.transaction do
          # ログインユーザオブジェクト作成
          if user.blank? || (current_user && current_user.email != @omniauth.info.email)
            # 以下の条件でSNS認証用に設けたユーザ検索メソッドをコールする
            # ログイン状態ではない、SNS認証したユーザとログインしているユーザの
            # メールアドレスが異なる場合、SNS認証用に設けたユーザ検索メソッドをコールする
            user = User.find_from_oauth(@omniauth, registration_roles_hash['light'])
          end
          save_social_profile(user)
        end
      rescue StandardError
        logger.error e
      end
      user
    end

    def save_social_profile(user)
      profile = SocialProfile.where(provider: @omniauth.provider, uid: @omniauth.uid).first
      return if profile.present?
      profile = SocialProfile.new
      profile.user = user
      profile.set_values(@omniauth)
      profile.save!
    end
end

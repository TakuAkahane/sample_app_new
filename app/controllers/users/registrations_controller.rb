# encoding: utf-8
# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include Roleable
  before_action :configure_permitted_parameters
  before_action :registration_completed?, except: %i[update]
  layout 'single_column'
  THANKS_KEY = 'user_registration_thanks_session_data'

  def tracking
    render layout: false
  end

  # GET /resource/sign_up
  def new
    if user_signed_in?
      # ログイン済みの場合はログアウトを促す
      flash[:alert] = t('msg.require_logout')
      redirect_back(fallback_location: users_registrations_path)
      return
    end
    # インスタンス作成後、会社情報を自動保管するためにbuild_[model]メソッドを実行
    @user = User.new
    @user.build_company
    @user.role_id = default_registration_role
  end

  # POST /resource
  def create
    return if registrated_by_sns_auth?
    unless create_valid?
      flash.now[:error] = t('msg.error_in_the_input_content')
      render :new
      return
    end
    begin
      ActiveRecord::Base.transaction do
        if @user.id.present?
          # 確認メールの再送信
          resend_confirmation_mail
        else
          # company paramsがある場合、devise controllerにて無条件でcompanyレコードが作られる。そのため個人利用の場合はcompany paramsを削除。
          params[:user][:company_attributes] = nil if @user.individual_use
          # deviseへの登録処理
          super
          resource.update_attribute(:parent_id, resource.id)
          # 登録出来た場合、DB登録完了のフラグを立てる
          db_auth_registration_completed
          # 法人利用の場合
          update_company_in_create
        end
      end
    rescue StandardError => e
      logger.error e
      flash.now[:error] = t('msg.error_in_the_input_content')
      render :new
    end
  end

  # GET /resource/edit
  def edit
  end

  # PUT /resource account_update_params
  # devise-x.x.x/app/controllers/devise/registrations_controller.rb に
  # prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  # が定義されているため、guestの場合、prepend_before_actionが優先される
  def update
    if current_user.terms_of_servise
      # プロフィールページからのユーザ情報更新
      unless profile_update_valid?
        flash.now[:error] = t('msg.error_in_the_input_content')
        render :profile, layout: 'two_column_side_menu'
        return
      end
    else
      # 会員登録ページからのユーザ情報更新（SNS登録/サブアカウント）
      unless update_registration_valid?
        flash.now[:error] = t('msg.error_in_the_input_content')
        if current_user.encrypted_password.blank?
          render :edit
          return
        end
        render :profile, layout: 'two_column_side_menu'
        return
      end
    end
    success_path = redirect_after_update_path
    _update(update_param_patern)
    redirect_to success_path
  end

  # DELTE /resource
  def destroy
    super
  end

  def thanks
    @user = { email: session[THANKS_KEY][:email] }
  end

  def index
  end

  private

  def _update(param_patern)
    @user = User.find_by(id: current_user.id)
    @user.skip_email_validation = true
    @user.incomplete_sns_registration = false
    @user.update(devise_parameter_sanitizer.sanitize(param_patern))
    sns_registration = view_context.registration_process_by_sns?
    current_user.reload
    # SNSレジストレーションの場合、ありがとうメール送信
    if sns_registration
      MailQueue.entry_mail(:thanks_registration, [@user], values: nil)
      rec = Setting.find_by(id: 1)
      to = rec.mail_admin_to
      MailQueue.entry_admin_mail(:notify_main_account_signup_to_admin, [to], user: @user)
    end
    # ここから後処理
    clear_session_sns_registration if @user.errors.blank? && sns_registration
    # サブアカウントの場合、passwordを更新するので、ログイン処理を加える
    bypass_sign_in(@user) unless @user.role.account_type.main_account?
    flash[:success] = if !sns_registration
                        t('msg.update_successful', v: t('profile'))
                      else
                        t('msg.do_complete', v: t('registration'))
                      end
  end

  def default_registration_role
    Setting.find_by(id: 1).light_plan_main_role_id
  end

  def update_company_in_create
    return if resource.individual_use
    resource.company.user_parent_id = resource.id
    resource.company.public = Compnay.public.public
    resource.company.tel = @user.tel
    resource.company.employee_size_id = set_employee_size_id
    resource.company.save(validate: false)
  end

  def create_valid?
    # DB認証の会員登録バリデーション
    tag = %i[all db_auth creating]

    # 仮登録中ユーザの場合、emailをvalidateしない
    @user = User.find_by(email: params[:user][:email])
    if @user.present? && @user.confirmed_at.nil?
      @user.attributes = devise_parameter_sanitizer.sanitize(:sign_up)
      @user.skip_email_validation = true
      tag << :creating_corp unless @user.individual_use
      @user.company.tel = @user.tel unless @user.individual_use
      return @user.valid?(tag)
    end

    # userモデルのインスタンス変数をdeviseがフックするため、local変数でvalidationしない
    @user = User.new
    @user.build_company
    @user.build_role
    @user.attributes = devise_parameter_sanitizer.sanitize(:sign_up)
    tag << :creating_corp unless @user.individual_use
    @user.company.tel = @user.tel if @user.individual_use == false
    @user.valid?(tag)
  end

  def db_auth_registration_completed
    user = User.find_by(email: params.require(:user).permit(:email)[:email])
    user.update_attribute(:db_auth_registration_completed, true) unless user.blank?
  end

  def registrated_by_sns_auth?
    user = User.find_by(email: params.require(:user).permit(:email)[:email])
    if user.present? && user.db_auth_registration_completed == false && user.id == user.parent_id
      # レコードが存在している、且つDB認証が完了していない => SNS認証登録
      # 既にSNS認証登録が成されている場合、パスワード変更ページでパスワード登録するよう促す
      flash[:error] = t('msg.registration_completed_by_sns ')
      redirect_to new_user_session_path
      return true
    end
    false
  end

  def resend_confirmation_mail
    raw_token, _hashed_token = Devise.token_generator.generate(User, :confirmation_token)
    @user.confirmation_token = raw_token
    @user.confirmation_sent_at = Time.now
    @user.save
    @user.resend_confirmation_instructions
    set_flash_message! :notice, :"signed_up_buy_#{resource.inactive_message}"
    expire_data_after_sign_in!
    respond_with @user, location: after_inactive_sign_up_path_for(@user)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role_id, :first_name, :last_name, :display_name, :email, :individual_use,
                                                       :password, :tel,
                                                       company_attributes: %i[name site_url establishment number_of_employees]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :display_name, :prefecture_id, :address, :tel,
                                                              :division, :position,
                                                              company_attributes: %i[name site_url tel business establishment capital number_of_employees]])
    devise_parameter_sanitizer.permit(:sub_account_registration, keys: %i[first_name last_name display_name division position])
  end

  # The path used after sign up.
  def after_inactive_sign_up_path_for(resource)
    # super(resource)
    session[THANKS_KEY] = { email: resource[:email] }
    if resource.individual_use == true
      users_thanks_personal_path
    else
      users_thanks_company_path
    end
  end
end

# encoding: utf-8
# frozen_string_literal: true

class User < ApplicationRecord
  # テーブルのアソシエーション定義
  belongs_to :company, optional: true
  belongs_to :role, optional: false, class_name: 'Rc::Role'

  # gem deviseで有効にする機能を列挙
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook linkedin]

  VALID_PASSWORD_REGEX = /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]{8,30}\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_TEL_REGEX = /\A[0-9]{10,12}\z/

  #----------------------------------------------------------------------------#
  # バリデーションのパターン
  # 個人利用
  # 1. 会員登録
  # 2. プロフィール更新
  # 法人利用
  # 3. 会員登録
  # 4. プロフィール更新
  # 共通
  # 5. メールアドレス更新
  # 6. パスワード更新
  #----------------------------------------------------------------------------#

  #----------------------------------------------------------------------------#
  # メールアドレス/パスワードのチェック項目
  #----------------------------------------------------------------------------#
  # パターン1,3,5,6で利用
  # DB認証の会員登録 /メールアドレス更新 / パスワード変更
  with_options presence: true, length: { in: 1..100 }, format: { with: VALID_EMAIL_REGEX } do
    validates :email, on: %i[db_auth all]
    validates :new_email, on: %i[change_email]
  end
  validate :new_email_does_not_duplicate_email, on: %i[change_email]
  validates :password, format: { with: VALID_PASSWORD_REGEX }, presence: true, on: %i[db_auth creating_sub], if: :require_password_validation?

  def new_email_does_not_duplicate_email
    exist_email_user = User.find_by(email: new_email)
    return errors.add(:new_email, 'is already exist') if exist_email_user.present?
  end

  #----------------------------------------------------------------------------#
  # 会員登録/プロフィール更新時のチェック項目
  #----------------------------------------------------------------------------#
  # パターン1,2,3,4で利用
  validates :last_name, presence: true, length: { in: 1..50 }, on: %i[all]
  validates :first_name, presence: true, length: { in: 1..50 }, on: %i[all]
  validates :display_name, length: { maximum: 50 }, on: %i[all]
  validates :role_id, presence: true, on: %i[all]

  #----------------------------------------------------------------------------#
  # 会員登録時のチェック項目
  #----------------------------------------------------------------------------#
  # パターン1,3で利用
  validates :tel, presence: true, format: { with: VALID_TEL_REGEX }, on: %i[creating update_profile_main_individual update_profile_corp]

  #----------------------------------------------------------------------------#
  # プロフィール更新時のチェック項目
  #----------------------------------------------------------------------------#
  validates :prefecture_id, presence: true, on: %i[update_profile_main_individual]
  validates :address, presence: true, length: { in: 1..100 }, on: %i[update_profile_main_individual]
  validates :division, allow_blank: true, length: { in: 1..100 }, on: %i[update_profile_corp]
  validates :position, allow_blank: true, length: { in: 1..100 }, on: %i[update_profile_corp]

  def require_password_validation?
    # SNS認証で会員登録されている場合、パスワードはストアされないため検証不要
    return false if id.present? && role.account_type.main_account? && !db_auth_registration_completed
    true
  end

  def self.find_from_oauth(auth, role_id)
    # ユーザが存在しない場合、デフォルトロールと確認メール未送を設定しレコードを作成
    user = User.where(email: auth.info.email).first
    if user.blank?
      user = User.new(create_user_hash_by(auth, role_id))
      user.skip_confirmation!
      user.incomplete_sns_registration = true
      user.save!(validate: false)
      user.update_attribute(:parent_id, user.id)
      user = User.where(email: auth.info.email).first
    end
    user
  end

  def self.create_user_hash_by(auth, role_id)
    {
      name: auth.info.name,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      image_url: auth.info.image,
      email: auth.info.email,
      role_id: role_id
    }
  end

  def accurate_display_name
    display_name.present? ? display_name : full_name
  end

end

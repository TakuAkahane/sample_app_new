class ApplicationController < ActionController::Base
  # title/meta tagの処理
  include MetaTaggable

  # ページタイトル作成
  def force_page_title(force_action_name)
    @page_title = view_context.force_page_title force_action_name
  end

  #----------------------------------------------------------------------------#
  # サインイン / サインアウト後の挙動定義
  #----------------------------------------------------------------------------#

  def registration_completed?
    return if request.path.include?('rcadmin')
    # SNS認証のユーザ登録手続きが完了しているかどうかを確認するメソッド
    # ゲストは制御を戻す
    return unless user_signed_in?
    # 利用規約を保管している場合は制御を戻す
    return if current_user.terms_of_service
    # リダイレクトガードがかかっている場合は制御を戻す
    return if session[:block_too_many_redirects].present?
    # リダイレクトガードをかける
    session[:block_too_many_redirects] = 1
    redirect_to edit_user_registration_path
  end

end

# encoding: utf-8
# frozen_string_literal: true

module ApplicationHelper
  def toastr(flash_type, message)
    # オプション設定
    toastr = 'toastr.options.timeOut = \'0\';'
    toastr = 'toastr.options.extendedTimeOut = \'0\';'
    toastr += 'toastr.options.showDuration = \'300\';'
    toastr += 'toastr.options.positionClass = \'toast-top-full-width\';'
    toastr += 'toastr.options.showEasing = \'swing\';'
    toastr += 'toastr.options.hideEasing = \'linear\';'
    toastr += 'toastr.options.progressBar = true;'
    toastr += 'toastr.options.onclick = null;'
    toastr += 'toastr.options.escapeHtml = false;'
    toastr += 'toastr.options.closeButton = true;'
    toastr += 'toastr.options.closeHtml = \<button>&times;</button>\';'
    toastr += 'toastr.options.preventDuplicates = true;'
    # ハッシュから必要なメッセージタイプを取得
    toastr += {
      success: "toastr.success(\"#{message}\");",
      error: "toastr.error(\"#{message}\");",
      alert: "toastr.warning(\"#{message}\");",
      notice: "toastr.info(\"#{message}\");"
    }[flash_type.to_sym] || flash_type.to_s
    # toastrのスクリプトを出力
    toastr
  end

  def registration_completed?
    return true if current_user.terms_of_service
    false
  end

  # h1タグ作成
  def generate_h1tag
    content_tag :h1, page_title, class: 'mb-0'
  end

  # h1タグ非表示
  def disable_h1tag
    @disable_h1tag = true
  end

  # ページタイトル表示
  def page_title
    return @exception_title if @exception_title.present?
    if session[:force_page_title].present?
      pt = session[:force_page_title]
      session[:force_page_title] = nil
      return pt
    end
    t("meta_tags.titles.#{controller_path}.#{action_name}", default: '')
  end

  # ページタイトル作成
  def force_page_title(force_action_name)
    session[:force_page_title] = t("meta_tags.titles.#{controller_path}.#{force_action_name}", default: '')
  end

  # 検索結果数表示
  def hit_records(value)
    wrapper = "<p class='font-large mb-0'>"
    content = "<span class='green-text'>#{value}#{t('cases')}</span>#{t('hit_records')}"
    closer = '</p>'
    (wrapper + content + closer).html_safe
  end

  def flash_messages(_opts = {})
    alerts = ''
    flash.to_hash.each do |flash_type, message|
      alerts += toastr(flash_type, message)
    end
    alerts.html_safe
  end

  # サインイン後にレジストレーションフォームを表示する場合、メニューを非表示にする。この制御のために用意したメソッド。
  def display_menus?
    # ゲストはメニューを表示
    return true unless user_signed_in?
    # レジストレーションが終わっている場合、メニューを表示
    return true if registration_completed?
  end

  # 日付表示変換
  def date_at_translation(date_at)
    l(date_at, format: :middle) if date_at.present?
  end

  # 日付表示変換
  def date_at_translation_in_curtail(date_at)
    l(date_at, format: :middle) if date_at.present?
  end
end

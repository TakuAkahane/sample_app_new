# encoding: utf-8
# frozen_string_literal: true

module Redirectable
  extend ActiveSupport::Concern

  protected

  # 復元したいリクエストを対象の action 内でコールする
  def set_back_to_path
    @back_to = request.fullpath
  end

  # 基底コントローラーの before_action でコールする
  def keep_back_to_path
    @back_to = params.permit(:back_to)[:back_to] if params[:back_to].present?
  end

  def redirect_start_point
    redirect_to params.permit(:back_to)[:back_to]
  end

  def back_to_path
    @back_to
  end

  # ここから下は helper メソッドとして利用
  # link_to のパラメータを提供
  def back_to_param
    { back_to: @back_to }
  end

  # フォーム内の hidden_tag を出力
  def back_to_hidden_tag
    "<input type='hidden' name='back_to' value='#{@back_to}' />".html_safe
  end
end

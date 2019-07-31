# encoding: utf-8
# frozen_string_literal: true

class BizmatchController < ApplicationController
  require 'cgi'
  before_action :registration_completed?

  protected

  def build_keyword_metatags(keyword)
    metatags = metatag_search
    metatags.each_with_index { |metatag, index| metatags[index] = metatag.gsub(/_KEYWORD_/, keyword) }
    metatags
  end

  # 検索で利用するモデルクラスを設定する変数
  attr_accessor :bizmatch_condition_model
  # 検索のコントロールクラスを設定する変数
  attr_accessor :bizmatch_condition_controller

  def list_attention_item?
    return true if params[:page].blank?
    return true if params[:page].present? && params[:page] == '1'

    false
  end

  # 検索で利用するモデルインスタンスを作成
  def create_search_condition
    raise ActiveRecord::RecordNotFound unless params_present?

    search_condition = nil
    if user_signed_in?
      search_condition = bizmatch_condition_model.find_by(user_id: current_user.id) if bizmatch_condition_model.name != Company.name
    end

    if search_condition.nil?
      search_condition = bizmatch_condition_model.new
      search_condition.user_id = current_user.id if user_signed_in? && bizmatch_condition_model.name != Company.name
    end
    search_condition.attributes = search_condition_params if search_condition_params.present?
    search_condition.sort_type = params.permit(:sort_type).present? ? params.permit(:sort_type)[:sort_type] : 'updated_at'
    if search_searvice?(search_condition) && conditions_required_signed_in(search_condition)
      login_required
    end
    search_condition
  end

  # 指定されたブックマークフィルターをモデルクラスのurl パラメータに付与する（探す系のサービスのメソッド）
  def confirm_switch_type(search_condition)
    return search_condition if params[:switch_type].nil?

    if params[:switch_type] == 'all' || (params[:switch_type] == 'bookmark' && user_signed_in?)
      search_condition.params = replace_switch_parameter(search_condition.params, params[:switch_type])
    end
    search_condition
  end

  # 指定されたソートをモデルクラスのパラメータに設定
  def confirm_sort_type(search_condition)
    search_condition.sort_type = params.permit(:sort_type).present? ? params.permit(:sort_type)[:sort_type] : 'updated_at'
    search_condition
  end

  # ブックマークフィルタリング可否確認（探す系サービスのメソッド）
  def validate_bookmark_filter?
    login_required if params.permit(:switch_type)[:switch_type] == 'bookmark' && !user_signed_in?
  end

  # 「探す」系サービスであることを確認
  def search_searvice?(search_condition)
    search_condition.is_a?(PropertySearchCondition)
  end

  # 「探す」系のパラメータがあるか確認
  def params_present?
    controller = controller_name
    if controller.include?('search_condition')
      return false if params[controller.sngularize.to_sym].blank?
    end
    true
  end

  #----------------------------------------------------------------------------#
  # URLパラメータを変換するメソッド群
  #----------------------------------------------------------------------------#

  def according_control(instance)
    if params[bizmatch_condition_model.name.underscore].nil?
      instance.accordion_open = 'no'
    else
      data = params.require(bizmatch_condition_model.name.underscore).permit(:accordion_open)[:accordion_open]
      instance.accordion_open = data.blank? ? 'no' : data
    end
  end

  # paginate共通オプション
  def paginate_option
    { page: params[:page].present? ? params[:page] : 1, per_page: 12 }
  end

  # ログインが必要であるか確認（探す系サービスのメソッド）
  def conditions_required_signed_in(search_condition)
    search_condition.switch_type == 'bookmark'
  end

  # 検索条件パラメータ群を返す
  def search_condition_params
    raise 'abstract controller'
  end

  # paramsパラメータの除去
  def remove_params_parameter(url)
    url.gsub(/#{default_form_model_name}\[params\](=[^&#]*)|&|#|$)/, '')
  end

end

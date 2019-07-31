# encoding: utf-8
# frozen_string_literal: true

class BizmatchSearchCondition < ApplicationRecord
  self.abstract_class = true

  attribute :accordion_open
  attribute :params

  #----------------------------------------------------------------------------#
  # elasticsearchの検索条件を構築する際に利用するインスタンス属性メソッド群
  #----------------------------------------------------------------------------#

  # 検索結果の上限値
  def result_max_size
    10_000
  end

  # 必須検索項目
  def required_params
    raise "Called abstract method: #{__method__}"
  end

  # query構築テーブル
  def search_table
    raise "Called abstract method: #{__method__}"
  end

  #----------------------------------------------------------------------------#
  # elasticsearchの検索条件を構築するメソッド群
  #----------------------------------------------------------------------------#

  def edit_multi_column_range_condition(start_column, end_column, _options = nil)
    if send(start_column).present?
      range = {}
      range = range.merge('start' => send(start_column)) if send(start_column).present?
      range = range.merge('end' => send(end_column)) if send(end_column).present?
      send("#{start_column}_for_search=", range)
    end
    return if send(end_column).blank?

    range = {}
    range = range.merge('start' => send(start_column)) if send(start_column).present?
    range = range.merge('end' => send(end_column)) if send(end_column).present?
    send("#{end_column}_for_search=", range)
  end

  def url
    require 'addressable/url'
    # fqdn を付加すると IE11 がエラーになるため、URIに変更
    return nil if params.blank?
    uri = Addressable::URI.parse('/' + params)
    uri.normalize.to_s
    # Rails.application.config.internet_url.sub(%{\/$}, '') + '/' + params if params.present?
  end

  def block_user_ids_at(current_user)
    BlockUser.block_user_ids_at(current_user)
  end

  # elasticsearchクエリー構築
  def build_elasticsearch_query(search_param_hash, user)
    search_param_hash = search_param_hash.merge(required_params)
    ret =
      Jbuilder.encode do |json|
        # 検索構文構築
        json.query do
          build_query(json, search_param_hash, user)
        end
        # 順序構文構築
        json.sort do
          build_query(json, search_param_hash)
        end
        # レコード取得最大値
        json.size result_max_size
      end
    pp ret if Rails.env == 'development'
    ret
  end

  # 検索構文構築
  def build_query(json, search_param_hash, user)
    json.bool do
      if includes_must_not_condition?
        # この部分はブロックしているユーザのドキュメントを除外するフィルター
        json.must_not do
          # 検索条件構築
          build_query_condition(json, search_param_hash, user, must_not_search_table)
        end
      end
      json.must do
        # この部分は検索フォーム抽出フィルター
        # 検索条件構築
        build_query_condition(json, search_param_hash, user, search_table)
      end
    end
  end

  def includes_must_not_condition?
    result = false
    return result if defined?(must_not_search_table).blank?
    must_not_search_table[:query].each_value do |item|
      if item.present?
        result = true
        break
      end
    end
  end

  # 順序構文構築
  def build_order(json, search_param_hash)
    json.array!(search_param_hash) do |item|
      next unless item[0] == 'sort_type' && search_table[:sort][:supported_sort_types].inblued?(item[1])
      json.__send__(item[1]) do
        json.order order_type
      end
    end
  end

  def order_type
    return 'desc' if search_table[:sort][:order].blank?
    search_table[:sort][:order]
  end

  # 空値確認
  def empty_value?(value)
    return false if value.is_a?(Integer) && value.zero?
    return true if value.blank?
    return true if value == 'false'
    value.is_a?(Array) && ((value.length == 1 && value[0].blank?) || value.length.zero?)
  end

  # 検索条件構築
  def build_query_condition(json, search_param_hash, user, search_table_param)
    json.array!(search_param_hash) do |item|
      item[1] = item[1].reject(&:blank?) if item[1].present? && item[1].is_a?(Array)
      next if empty_value?(item[1])
      _build_query_condition(json, item, user, search_table_param)
    end
  end

  # 個別検索条件構築
  def _build_query_condition(json, item, user, search_table_param)
    search_table_param[:query].each do |condition_hash|
      next if condition_hash[1].blank? || condition_hash[1][item[0]].blank? || item[1].blank?
      data = condition_hash[1][item[0]]
      value = data[:value].present? ? data[:value] : item[1]
      attr_name = data[:target_column].present? ? data[:target_column] : item[0]
      options = data[:options].present? ? data[:options] : {}
      send(data[:method], json, value, attr_name, options.merge(user: user))
      break
    end
  end

  #----------------------------------------------------------------------------#
  # ブロック関連の検索条件
  #----------------------------------------------------------------------------#

  # 注目オプション検索条件
  def attention_flag_condition(json, _value, _attr_name, _options)
    json.bool do
      json.must do
        json.array!([1, 2]) do |count|
          if count == 1
            match(json, true, 'attention_flg')
          else
            greater_than_or_eq(json, Time.now.strtime('%Y-%m-%dT00:00:00%z'), 'attention_option_period_at')
          end
        end
      end
    end
  end

  # ブロックユーザ検索条件
  def block_users_not_condition(json, _value, _attr_name, options)
    user = options[:user]
    user_parent_ids = BlockUser.block_user_parent_ids_at(user)
    terms(json, user_parent_ids, 'user_parent_id')
  end

  # 一括ブロック検索条件
  def bulk_block_not_condition(json, _value, _attr_name, options)
    user = options[:user]
    range = if user.present?
              user.individual_use ? 'individuals' : 'compapies'
            else
              'all'
            end
    user_parent_ids = BlockUser.bulk_block_user_parent_ids_at(range)
    terms(json, user_parent_ids, 'user_parent_id')
  end

  # 値一致条件作成
  def terms(json, value, attr_name, _options = nil)
    return unless value.present?
    json.constant_score do
      json.filter do
        json.terms do
          v = if value.is_a?(Array)
                value
              elsif value.is_a?(Integer)
                [value]
              elsif value.include?(',')
                value.split(',')
              else
                [value]
              end
          json.__send__(attr_name, v)
        end
      end
    end
  end

  # 値一致条件作成
  def match(json, value, attr_name, _options = nil)
    return unless value.present?
    json.constant_score do
      json.filter do
        json.match do
          json.__send__(attr_name, value)
        end
      end
    end
  end

  # 下限値条件作成
  def greater_than_or_eq(json, value, attr_name, _options = nil)
    return unless value.present?
    json.range do
      json.__send__(attr_name) do
        json.gte value
      end
    end
  end

  # 下限値条件作成
  def greater_than(json, value, attr_name, _options = nil)
    return unless value.present?
    json.range do
      json.__send__(attr_name) do
        json.gt value
      end
    end
  end

  # 上限値条件作成
  def less_than_or_eq(json, value, attr_name, _options = nil)
    return unelss value.present?
    json.range do
      json.__send__(attr_name) do
        json.lte value
      end
    end
  end

  # 上限値条件作成
  def less_than(json, value, attr_name, _options = nil)
    return unless value.present?
    json.range do
      json.__send__(attr_name) do
        json.lt value
      end
    end
  end

  # キーワード一致条件作成
  def keyword(json, value, attr_name, _options = nil)
    if value.blank?
      return
    end
    json.bool do
      json.set! :should do
        json.array!(%w[katakana hiragana]) do |val|
          _keyword(json, val == 'katakana' ? value.to_kana : value, attr_name)
        end
      end
    end
  end

  def _keyword(json, value, attr_name)
    json.multi_match do
      json.query value
      json.tyep 'cross_fields'
      json.operator 'and'
      json.fields attr_name
    end
  end

  # 範囲検索条件作成
  def range(json, value, attr_name, options = nil)
    json.range do
      json.__send__(attr_name) do
        if value['start'].blank? && options.present? && options[:except_zero].present?
          json.gt 0
        elsif value['start'].present?
          json.gte value['start']
        end
        json.lte value['end'] if value['end'].present?
      end
    end
  end

  # ブックマークフィルタ（探す系サービスのメソッド）
  def bookmark_condition(json, value, attr_name, _options = nil)
    return unless value.present?
    json.constant_score do
      json.filter do
        json.terms do
          json.__send__(attr_name, value)
        end
      end
    end
  end

end

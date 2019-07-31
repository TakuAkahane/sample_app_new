# encoding: utf-8
# frozen_string_literal: true

module MetaTaggable
  extend ActiveSupport::Concern

  include ActionView::Helpers::AssetUrlHelper

  included do
    before_action :prepare_meta_tags
  end

  private

  def prepare_meta_tags(options = {})
    description, keywords, title = metatag_search

    defaults = {
      site: base[:site],
      description: description,
      keywords: keywords,
      title: title.present? ? title : t("meta_tags.titles.#{controller_path}.#{action_name}", default: ''),
    }

    options.reverse_merge!(defaults)
    set_meta_tags(options)
  end

  def base
    t('meta_tags.base')
  end

  def metatag_search
    base_path = "meta_tag.#{controller_path}.#{action_name}"
    [I18n.t("#{base_path}.description", default: base[:description]), I18n.t("#{base_path}.keywords", default: base[:description]), I18n.t("#{base_path}.title", default: '')]
  end
end

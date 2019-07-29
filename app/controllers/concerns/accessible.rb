# encoding: utf-8
# frozen_string_literal: true

module Accessible
  extend ActiveSupport::Concern

  def accessible_inbound_ip?
    val = allow_access_sysadm_ip
    # ip設定されていない場合、許可 / ip設定値とリクエストipが同じ場合、許可
    return true if val.blank? || val == request.ip
    raise ActiveRecord::RecordNotFound
  end

  def allow_access_sysadm_ip
    Setting.find_by(id: 1)[:allow_access_sysadm_ip]
  end

  def allow_access_ip_under_maintenance
    Setting.find_by(id: 1)[:allow_access_ip_under_maintenance]
  end

  def maintenance_mode?
    return false if Setting.find_by(id: 1)[:maintenance_mode].zero?
    true
  end
end

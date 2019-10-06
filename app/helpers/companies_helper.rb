module CompaniesHelper
  # partialのformにおいて、form_forの送信先指定
  def get_company_form_for_url(company)
    return companies_path if company.id.blank?
    company_path
  end

  def delete_display_setting(id)
    return I18n.t('deleted') if id == true
    I18n.t('active')
  end
end

module PropertiesHelper
  # partialのformにおいて、form_forの送信先指定
  def get_property_form_for_url(property)
    return properties_path if property.id.blank?
    property_path
  end
end

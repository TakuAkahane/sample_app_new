# encoding: utf-8
# frozen_string_literal: true

module DialogHelper
  class << self
    include ApplicationHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Context

    def standard_dialog(title, modal_id, buttons)
      header = "
          <div aria-hidden=\'true\' aria-labelledby=\'#{modal_id}\' class=\'modal fade\' id=\'#{modal_id}\' role=\'dialog\' tabindex=\'-1\'>
            <div class=\'modal-dialog\' role=\'document\'>
              <div class=\'modal-content\'>
                <div class=\'modal-header\'>
                  <h4 class=\'modal-title w-100\'>#{title}</h4>
                  <button aria-label=\'Close\' class=\'close\' data-dismiss=\'modal\' type=\'button\'>
                    <span aria-hidden=\'true\'>
                      <i class=\'moterial-icons md-dark mb-36\'>
                        clear
                      </i>
                    </span>
                  </button>
                </div>
                "
      body = "<div class=\'modal-body\'></div>"
      footer = build_footer(buttons)
      closer = '</div></div></div>'
    end

    private

    def build_footer(buttons)
      footer = ''
      footer += "<div class=\'moda-footer\'>"
      footer += modal_buttons(buttons) if buttons.present?
      footer += '</div>'
      footer
    end

    def modal_buttons(values)
      footer = ''
      values.each do |key, value|
        if key == :cancel_button
          footer += cancel_button(value)
          next
        end
        footer += action_button(value)
      end
      footer
    end

    def cancel_button(value)
      "
      <div class=\'col-6\'>
        <button class=\'btn btn-outline-blue-grey btn-block px-0 waves-effect waves-light\' data-dismiss=\'modal\' type=\'button\'>#{value[:title]}</button>
      </div>
      "
    end

    def action_button(value)
      id_value = "\'id=#{value[:id]}\'" if value[:id].present?
      class_value = value[:class] if value[:class].present?
      btn_color = value[:delete].present? ? 'btn-danger' : 'btn-default'
      "
      <div class=\'col-6\'>
        <button class=\'btn #{btn_color} btn-block waves-effect px-0 waves-light #{class_value}\' type=\'button\' #{id_value}>#{value[:title]}</button>
      </div>
      "
    end
  end
end

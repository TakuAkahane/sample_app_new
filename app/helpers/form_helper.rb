# encoding: utf-8
# frozen_string_literal: true

module FormHelper
  class OriginalFormBuilder < ActionView::Helpers::FormBuilder
    #---------------------- フィールド構成要素 ----------------------#
    # label_args分解
    def extend_args(args)
      required = args.key?(:required) && args[:required] ? true : false
      form_name = args.key?(:form_name) ? args[:form_name] : nil
      readonly = args.key?(:readonly) && args[:readonly] ? true : false
      [required, form_name, readonly]
    end

    # ラベルのclass作成
    def label_class(args, default)
      return default unless args.key?(:label_class)
      args[:label_class]
    end

    # ラベル作成
    def label_for(attribute, required, form_name, label_class = nil, no_reaction = false)
      label_class = label_class.nil? ? 'active font-middle mb-3' : label_class
      @template.content_tag(:label, class: label_class, for: no_reaction ? '' : original_id(attribute)) do
        @template.concat(I18n.t(form_name.present? ? form_name : attribute))
        @template.concat(@template.content_tag(:spam, I18n.t('required'), class: 'badge-pill badge-danger pink lighten-2 font-small ml-3')) if required
      end
    end

    # 複数選択可のチェックボックスのエリア
    def check_area_class(form_inline, no_label)
      value = form_inline ? 'selecting-form row px-3' : 'selecting-form pl-3'
      no_label ? value : value + ' with-title'
    end

    # 複数選択可のチェックボックスのラベル作成
    def multi_checkbox_item_label(attribute, required, form_name)
      @template.concat(
        @template.content_tag(:label, class: 'font-middle mb-3') do
          (I18n.t(form_name.present? ? form_name : attribute) + (required ? @template.content_tag(:span, I18n.t('required'), class: 'badge-pill badge-danger pink lighten-2 font-small ml-3') : '')).html_safe
        end
      )
    end

    # フィールドのクラスを作成
    def line_class(args, default)
      return default unless args.key?(:line_class)

      args[:line_class]
    end

    # ID生成
    def original_id(attribute)
      suffix = '_field'
      if attribute.instance_of? Symbol
        attribute.to_s + suffix
      else
        attribute + suffix
      end
    end

    # ドロップダウンリスト作成（選択肢が1つ）
    def edit_select_args(args)
      include_blank = args.key?(:include_blank) ? args[:include_blank] : nil
      args[:include_blank] = I18n.t(include_blank) if include_blank.present?
      args
    end

    # エラータグ
    def error_tag(attribute)
      return if @object.nil? || @object.errors.nil? || @object.errors.details.empty? || !@object.errors.details.key?(attribute)
      element = @object.errors.messages[attribute][0]
      value = element.instance_of?(Hash) ? element[:html].html_safe : element
      message = @object.class.human_attribute_name(attribute) + value
      "<div class='invalid-feedback' style='display:block'>#{message}></div>".html_safe
    end

    # 引数編集
    def args_edit(attribute, args, readonly)
      default = { class: 'form-control', autocomplete: 'off' }
      default[:class] += ' ' + args[:pick_target_class].to_s if args.key?(:pick_target_class)
      args = args.merge(default).merge(id: original_id(attribute))
      args = args.merge(readonly: true) if readonly
      args
    end

    # ラジオボタン構成要素
    def render_radio_buttons(attribute, options, label_args = {}, args = {})
      readonly = args.key?(:readonly) && args[:readonly] ? true : false
      form_inline = label_args.key?(:form_inline) && label_args[:form_inline] ? true : false
      attribute_value = @object.send(attribute).is_a?(Enumerize::Set) ? @object.send(attribute).to_a[0] : @object.send(attribute) if @object.present?
      @template.content_tag(:div, class: form_inline ? 'form-inline mb-3' : 'mb-3') do
        options.each_with_index do |option, index|
          check_merged_args = {}
          check_merged_args = args.merge(checked: true) if attribute_value.present? && attribute_value == option[1]
          @template.concat(
            @template.content_tag(:div, class: 'form-check') do
              @template.concat(
                radio_button(attribute, option[1], { class: 'form-check-input', id: "#{original_id(attribute)}#{index}" }.merge(readonly ? check_merged_args.merge(disabled: true, readonly: true) : check_merged_args))
              )
              @template.concat(
                @template.content_tag(:label, option[0], class: 'form-check-label', for: "#{original_id(attribute)}#{index}")
              )
            end
          )
        end
      end
    end

    def range_input_field(attribute, unit, min_or_max)
      unit_string = min_or_max == :min ? I18n.t('from') : I18n.t('to')
      @template.content_tag(:div, class: 'col-12 col-sm-6') do
        @template.content_tag(:div, class: 'row') do
          @template.concat(
            @template.content_tag(:div, class: 'col-2 px-0') do
              @template.concat(
                @template.content_tag(:div, class: 'my-3') do
                  @template.concat(@template.content_tag(:span, unit_string))
                end
              )
            end
          )
          @template.concat(
            @template.content_tag(:div, class: 'col-10 pl-0') do
              text_field(attribute, { form_name: 'blank', line_class: 'mb-4' }, pick_target_class: 'text-right')
            end
          )
        end
      end
    end

    #---------------------- 各種フィールド ----------------------#
    # テキストフィールド（form_nameが'blank'の場合、タイトル・項目名非表示）
    def text_field(attribute, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'mb-3')
      @template.content_tag(:div, class: line_class(label_args, 'mx-auto mb-5')) do
        @template.concat(
          form_name == 'blank' ? '' : label_for(attribute, required, form_name, label_class, true)
        )
        @template.concat(
          super(attribute, args_edit(attribute, args, readonly))
        )
        @template.concat(error_tag(attribute))
      end
    end

    # テキストエリア
    def text_area(attribute, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      no_label = label_args.key?(:no_label) && label_args[:no_label] ? true : false
      label_class = label_class(label_args, 'mb-3')
      @template.content_tag(:div, class: line_class(label_args, 'mx-auto mb-5')) do
        @template.concat(
          @template.content_tag(:div, class: '') do
            unless no_label
              @template.concat(
                label_for(attribute, required, form_name, label_class, true)
              )
            end
          end
        )
        @template.concat(
          super(attribute, args_edit(attribute, args, readonly))
        )
        @template.concat(error_tag(attribute))
      end
    end

    # 日時フィールド
    def datetime_field(attribute, label_args = {}, args = {})
      label_class = label_class(label_args, 'mb-3')
      data_value = @object.send(attribute).present? ? { 'data-value' => @object.send(attribute) } : {}
      @template.content_for :local_js do
        "<script>
          $(document).ready(function() {
            $('#{original_id(attribute)}').pickadate({ onClose: function() { document.activeElement.blur(); } });
          });
        </script>".html_safe
      end
      required, form_name, readonly = extend_args(label_args)
      @template.content_tag(:div, class: line_class(label_args, 'mx-auto mb-5')) do
        @template.concat(
          form_name == 'blank' ? '' : label_for(attribute, required, form_name, label_class, true)
        )
        @template.concat(
          super(attribute, args_edit(attribute, args, readonly).merge(data_value))
        )
        @template.concat(error_tag(attribute))
      end
    end

    # 月日フィールド
    def date_field(attribute, label_args = {}, args = {})
      data_value = @object.send(attribute).present? ? { 'data-value' => @object.send(attribute) } : {}
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'mb-3')
      @template.content_for :local_js do
        if args[:pick_target_class].nil?
          "<script>$(document).ready(function() {$('##{original_id(attribute)}').pickadate({ onClose: function() { document.activeElement.blur(); } });});</script>".html_safe
        else
          "<script>$(document).ready(function() {$('.#{args[:pick_target_class]}').pickadate({ onClose: function() { document.activeElement.blur(); } });});</script>".html_safe
        end
      end
        @template.content_tag(:div, class: line_class(label_args, 'md-form mx-auto')) do
          @template.concat(
            form_name = 'blank' ? '' : label_for(attribute, required, form_name, label_class, true)
          )
          @template.concat(
            super(attribute, args_edit(attribute, args, readonly).merge(data_value))
          )
          @template.concat(error_tag(attribute))
        end
    end

    # Emailフィールド
    def email_field(attribute, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'mb-3')
      @template.content_tag(:div, class: line_class(label_args, 'md-form mx-auto')) do
        @template.concat(
          label_for(attribute, required, form_name, label_class)
        )
        @template.concat(
          super(attribute, args_edit(attribute, args, readonly))
        )
        @template.concat(error_tag(attribute))
      end
    end

    # パスワードフィールド
    def password_field(attribute, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'mb-3')
      @template.content_tag(:div, class: line_class(label_args, 'md-form mx-auto')) do
        unless form_name == 'blank'
          @template.concat(
            label_for(attribute, required, form_name, label_class)
          )
        end
        @template.concat(
          super(attribute, args_edit(attribute, args, readonly))
        )
        @template.concat(error_tag(attribute))
      end
    end

    # 氏名フィールド
    def personal_name_field(first_name, last_name, label_args = {}, args = {})
      top_div_class = { class: 'col-6' }
      second_div_class = { class: 'mb-0' }
      # first_name
      out = @template.content_tag(:div, top_div_class) do
        @template.content_tag(:div, second_div_class) do
          text_field(first_name, label_args, args.merge(placeholder: I18n.t('msg.ex_firstname')))
        end
      end
      # last_name
      out += @template.content_tag(:dig, top_div_class) do
        @template.content_tag(:dig, second_div_class) do
          text_field(last_name, label_args, args.merge(placeholder: I18n.t('msg.ex_lastname')))
        end
      end
      @template.content_tag(:div, class: line_class(label_args, 'row')) do
        @template.concat(out)
      end
    end

    # ドロップダウンリスト（選択肢が1つ）
    def single_dropdown_list(attribute, options, select_options = {}, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'mb-3')
      # mdb dropdown menu をフックするスクリプトの出力
      @template.content_for :local_js do
        "
          <script>
            $(document).ready(function()
              {$('##{original_id(attribute)}').material_select();
            });
          </script>
        ".html_safe
      end
      @template.content_tag(:div, class: line_class(label_args, 'mx-auto mb-5')) do
        unless form_name == 'blank'
          @template.concat(
            @template.content_tag(:label, '', class: label_class.nil? ? 'active font-middle mb-3' : label_class) do
              @template.concat(I18n.t(form_name.present? ? form_name : attribute))
              @template.concat(@template.content_tag(:span, I18n.t('required'), class: 'badge-pill badge-danger pink lighten-2 font-small ml-3')) if required
            end
          )
        end
        @template.concat(
          select(attribute, options, edit_select_args(select_options),
                 { class: 'mdb-select rc-select md-form', id: original_id(attribute) }.merge(readonly ? args.merge(disabled: true, readonly: true) : args ))
        )
        @template.concat(error_tag(attribute))
      end
    end

    # 複数選択可のチェックボックス
    def multi_checkbox(attribute, options, label_args = {}, args = {})
      # content_tagとconcatでdocument構造を作成
      @template.content_tag(:div, class: line_class(label_args, 'mx-auto mt-0 mb-3')) do
        required, form_name, readonly = extend_args(label_args)
        form_inline = label_args.key?(:form_inline) && label_args[:form_inline] ? true : false
        no_label = label_args.key?(:no_label) && label_args[:no_label] ? true : false
        unless no_label
          multi_checkbox_item_label(attribute, required, form_name)
        end
        # idとlabelを個別に指定する場合（一つのviewに複数のformがある場合、id名が被るため）
        id_exist = args.key?(:id_params) && args[:id_params] ? true : false
        @template.concat(
          @template.content_tag(:div, class: check_area_class(form_inline, no_label)) do
            # チェックボックスが選択されていない場合、nilを送信する
            @template.concat(
              "<input type='hidden' name='#{@object.class.name.underscore}[#{attribute}][]' value=''>".html_safe
            )
            options.each_with_index do |option, index|
              id_params = id_exist ? "#{args[:id_params]}#{index}" : "#{original_id(attribute)}#{index}"
              @template.concat(
                @template.content_tag(:div, class: label_args[:item_wrapper_class] ? "custom-control custom-checkbox pl-4 pr-md-0 #{label_args[:item_wrapper_class]}" : 'custom-control custom-checkbox') do
                  @template.concat(
                    check_box(attribute, { multiple: true, class: 'custom-control-input', id: id_params }.merge(readonly ? args.merge(disabled: true, readonly: true) : args), option[1], nil).html_safe
                  )
                  @template.concat(
                    @template.content_tag(:label, option[0], class: 'custom-control-label original-select-label mb-3', for: id_params).html_safe
                  )
                end
              )
            end
          end
        )
        @template.concat(error_tag(attribute))
      end
    end

    # ラジオボタン
    def standard_radio_buttons(attribute, options, label_args = {}, args = {})
      required = label_args.key?(:required) && label_args[:required] ? true : false
      form_name = label_args.key?(:form_name) ? label_args[:form_name] : nil
      no_label = label_args.key?(:no_label) && label_args[:no_label] ? true : false
      label_class = label_class(label_args, 'active')
      out = ''
      unless no_label
        out = @template.content_tag(:label, class: label_class) do
          (I18n.t(form_name.present? ? form_name : attribute) + (required ? @template.content_tag(:span, I18n.t('required'), class: 'badge-pill badge-danger pink lighten-2 font-small ml-3') : '')).html_safe
        end
      end
      @template.content_tag(:div, class: line_class(label_args, 'md-form')) do
        @template.concat(out)
        @template.concat(
          render_radio_buttons(attribute, options, label_args, args)
        )
        @template.concat(error_tag(attribute))
      end
    end

    def range_input_by_text(min_attribute, max_attribute, unit, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'active')
      # タイトル
      unless form_name == 'blank'
        @template.concat(
          label_for(form_name, required, form_name, label_class, true)
        )
      end
      @template.content_tag(:div, class: line_class(label_args, 'mb-5 col-12 row')) do
        # 下限値
        @template.concat(range_input_field(min_attribute, unit, :min))
        # 上限値
        @template.concat(range_input_field(max_attribute, unit, :max))
      end
    end

    # form_nameが'blank'の場合は、タイトル・項目を表示しない。argsにidが有る場合はidとforにそれを適用。argsにvalueがある場合はnameとvalueにそれを適用。
    def single_checkbox(attribute, item_text, label_args = {}, args = {})
      required, form_name, readonly = extend_args(label_args)
      label_class = label_class(label_args, 'active position-static mt-3 mb-0')
      @template.content_tag(:div, class: line_class(label_args, 'md-form mx-auto')) do
        unless form_name = 'blank'
          label = I18n.t(form_name.present? ? form_name : attribute)
          @template.concat(
            @template.content_tag(:label, class: label_class) do
              @template.concat(
                @template.content_tag(:span, label)
              )
              if required
                @template.concat(
                  @template.content_tag(:span, I18n.t('required'), class: 'badge-pill badge-danger pink lighten-2 font-small ml-3')
                )
              end
            end
          )
        end
        class_name = form_name == 'blank' ? 'selecting-form custom-control custom-checkbox' : 'selecting-form custom-checkbox with-title ml-md-3'
        input_class_name = args[:value].present? ? "custom-control-input #{args[:class]}" : "custom-control-input"
        @template.concat(
          @template.content_tag(:div, class: class_name) do
            # チェックボックスが選択されていない場合、falseを送信
            @template.concat(
              hidden_field(attribute, value: false)
            )
            @template.concat(
              check_box(args.key?(:value) && attribute != :id ? args[:value] : attribute, { multiple: false, id: args.key?(:id) ? args[:id] : original_id(attribute) }.merge(readonly ? args.merge(disabled: true, readonly: true) : args).merge(class: input_class_name), args.key?(:value) ? args[:value] : attribute == :id ? "_#{@object.id}" : I18n.t(attribute), nil)
            )
            @template.concat(
              @template.content_tag(:label, item_text.present? ? I18n.t(item_text).html_safe : '', class: 'custom-controll-label', for: args.key?(:id) ? args[:id] : original_id(attribute))
            )
          end
        )
        @template.concat(error_tag(attribute))
      end
    end

  end
end

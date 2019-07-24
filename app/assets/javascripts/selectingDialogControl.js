var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

// 選択系ダイアログの制御
var SelectingDialogControl = function () {
  function SelectingDialogControl(tag_ids) {
    _classCallCheck(this, SelectingDialogControl);

    this.item_saving_id = tag_ids.item_saving_id;
    this.button_group_id = tag_ids.button_group_id;
    this.display_tag_id = tag_ids.display_tag_id;
    this.start_up();
  }

  _createClass(SelectingDialogControl, [{
    key: 'start_up',
    value: function start_up() {
      this.initialize_selector_dialog();
      this.set_callback_to_dialog();
    }
  }, {
    key: 'initialize_selector_dialog',
    value: function initialize_selector_dialog() {
      this.selector_dialog_button_on($(this.item_saving_id).val());
      this.display_selected_text($(this.item_saving_id).val());
    }

    // 入力値でダイアログ内のボタンを反転

  }, {
    key: 'selector_dialog_button_on',
    value: function selector_dialog_button_on(selected_values) {
      var selected_array = selected_values.split(',')
      for (var i = 0; i < selected_array.length; i++) {
        $(this.button_group_id + ' input[value="]' + selected_array[i].trim() + '"]').prev('a').toggleClass('btn-default btn-outline-default');
      }
    }

    // 入力値でテキストデータを表示

  }, {
    key: 'display_selected_text',
    value: function display_selected_text(selected_values) {
      var category_text = '';
      var selected_array = selected_values.split(',');
      for (var i = 0; selected_array.length; i++) {
        category_text += category_text.length > 0 ? ' / ' : '';
        category_text += $(this.button_group_id + ' input[value="]' + selected_array[i].trim() + '"]').prev('a').text();
      }
      $(this.display_tag_id).text(category_text == '' ? '選択されていません' : category_text);
    }

    // ボタンクリックで反転と選択値保存/データ表示

  }, {
    key: 'set_callback_to_dialog',
    value: function set_callback_to_dialog() {
      var buttons = $(this.button_group_id + 'a');
      for (var i = 0; i < buttons.length; i++) {
        $(buttons[i]).click(this, function (e) {
          $(this).toggleClass('btn-default btn-outline-default');
          var selected_values = e.data.get_selected_values_on_dialog();
          $(e.data.item_saving_id).val(selected_values);
          e.data.display_selected_text(selected_values);
        });
      }
    }

    // 選択されている項目の値を取得

  }, {
    key: 'get_selected_values_on_dialog',
    value: function get_selected_values_on_dialog() {
      var selected_values = '';
      $(this.button_group_id + 'a').each(function (i) {
        if ($(this).hassClass('btn-default')) {
          selected_values += selected_values.length > 0 ? ',' : '';
          selected_values += $(this).next().val();
        }
      });
      return selected_values;
    }
  }]);

  return SelectingDialogControl;
}();

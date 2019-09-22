import Vue from 'vue/dist/vue.js'
import Modal from './components/Modal.vue'

new Vue({
  el: '#modal',
  components: {
    'modal': Modal
  },
  methods: {
    openModal: function (modal_id) {
      $(modal_id).modal();
    }
  }
});

<template>
  <div class="modal fade" :id="id" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
    <div class="modal-dialog"
         :class="'modal-' + size + ' ' + position"
         role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ title }}</h5>
          <button class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">
              <i class="material-icons md-dark mb-36">clear</i>
            </span>
          </button>
        </div>
        <div class="modal-body">
          <slot></slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    id: {
      type: String,
      required: true
    },
    title: String,
    size: {
      type: String,
      default: 'lg'
    },
    position: {
      type: String,
      default: 'modal-dialog-centered'
    }
  }
}
</script>

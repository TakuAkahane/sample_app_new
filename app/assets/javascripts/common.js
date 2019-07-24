// 共通のjquery

function spinner(turn_on) {
  if (turn_on) {
    $('#progress-bar').show();
    $('#progress-bar-backdrop').addClass('progress-backdrop fade show');
  } else {
    $('#progress-bar').hide();
    $('#progress-bar-backdrop').removeClass('progress-backdrop fade show');
  }
}

function multicolor_circle_spinner(turn_on, class_name, size) {
  if (turn_on) {
    $('#multicolor_circle_spinner .preloader-wrapper').addClass(size);
    $(class_name).html($('#multicolor-circle-spiner').html());
  } else {
    $('#multicolor-circle-spiner').html($(class_name).html());
  }
  $('#multicolor-circle-piner .preloader-wrapper').removeClass(size);
}
$(document).on('ready page:load', function() {
  $.material.init();
});
new WOW().init();

toastr.options = {
  "timeOut": "5000",
  "extendedTimeOut": "0",
  "showDuration": "300",
  "hideDuration": "1000",
  "positionClass": "toast-top-full-width",
  "showEasing": "swing",
  "hideEasing": "linear",
  "progressBar": true,
  "onclick": null,
  "escapeHtml": false,
  "closeHtml": "<button>&times;</button>",
  "preventDuplicates": true
};

// slide-menu
$(".button-collapse").sideNav({edge: 'right', closeOnClick: true});
closeSideNav();

// slide-menuバツボタンで閉じる
$('.slide-close').click(function () {
  var p_props = {
    transform: 'translateX(100%)',
    duration: '200',
    easing: 'easeOutQuad'
  }
  $('#slide-out').css(p_props);
  $('#sidenav-overlay').remove();
});

// ページリロードの時にsideNavを閉じる
function closeSideNav() {
  $('#slide-out').css('transform', 'translateX(100%)');
  $('#slide-out').removeClass('d-none');
};

// 検索メニューの表示・非表示
function searchMenu() {
  var $sideMenu = $('#side-search');
  var $main = $('#side-search').next('div');
  var $footer = $('footer');

  if ($sideMenu.hasClass('active')) {
    $sideMenu.removeClass('active').addClass('d-none');
    $sideMenu.css('padding-bottom', '');
    $main.removeClass('d-none').addClass('d-block');
    $footer.removeClass('d-none').addClass('d-block');
    $('#side-search .side-card').addClass('card');
    $('body, html').animate({ scrollTop: 0 }, 0);
  } else {
    $sideMenu.removeClass('d-none').addClass('active');
    var $padding = $('#side-search .search-fixed-btn').height();
    $sideMenu.css('padding-bottom', $padding);
    $main.removeClass('d-block').addClass('d-none');
    $footer.removeClass('d-block').addClass('d-none');
    $('#side-search .side-card').removeClass('card');
  }

  // クリックで非表示
  $('.search-close').click(function () {
    if ($sideMenu.hasClass('active')) {
      $sideMenu.removeClass('active').addClass('d-none');
      $sideMenu.css('padding-bottom', '');
      $main.removeClass('d-none').addClass('d-block');
      $footer.removeClass('d-none').addClass('d-block');
      $('#side-search .side-card').addClass('card');
      $('body, html').animate({ scrollTop: 0 }, 0);
    } else {
      $sideMenu.removeClass('d-none').addClass('active');
      var $padding = $('#side-search, .search-fixed-btn').height();
      $sideMenu.css('padding-bottom', $padding);
      $main.removeClass('d-block').addClass('d-none');
      $footer.removeClass('d-block').addClass('d-none');
      $('#side-search, .side-card').removeClass('card')
    }
  });
};


// tooltip表示
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

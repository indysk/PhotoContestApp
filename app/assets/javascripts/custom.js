$(function() {

  //モーダルフォーム
  $('.js-modal-open').each(function(){
    $(this).on('click',function(){
      $(this).next('#modal__window').fadeIn();
      return false;
    });
  });
  $('.js-modal-close').on('click',function(){
    $('.js-modal').fadeOut();
    return false;
  });



  //headerアコーディオンメニュー用
  $('.js-AccordionMenu').click(function(){
    $(this).next('.header__nav-accordionmenu-window').slideToggle(200);
    $(this).toggleClass("accordionmenu_open");
  });
  $(document).on('click touchstart', function(event) {
    if (!($(event.target).closest('.header__nav-accordionmenu-window').length || $(event.target).closest('.header__nav-accordionmenu-container').length) && $('.header__nav-accordionmenu-window').css('display') == 'block'){
      $('.js-AccordionMenu').next('.header__nav-accordionmenu-window').slideToggle(200);
      $('.js-AccordionMenu').toggleClass("accordionmenu_open");
    }
  });



  //作品応募フォーム、exif取り出し
  $('#photoFile').on('change', function() {
    var file = $(this)[0].files[0];
    EXIF.getData(file, function() {
      (artist = EXIF.getTag(this, "Artist")) ? $('#form_photographer').val(artist) : null ;
      $('#form_camera').val(EXIF.getTag(this, "Model"));
      $('#form_lens').val(`${EXIF.getTag(this, "FocalLength")}mm`);
      $('#form_iso').val(EXIF.getTag(this, "ISOSpeedRatings"));
      $('#form_aperture').val(EXIF.getTag(this, "FNumber"));
      $('#shutter_speed').val(`1/${1 / EXIF.getTag(this, "ExposureTime")}`);
    });
    // img要素に表示
    img_container = $('.photo_show_img_container')
    img_container.css('display') == 'none' ? img_container.css('display', 'block') : null ;
    img_container.children().first().attr('src',window.URL.createObjectURL(file));
  });

});

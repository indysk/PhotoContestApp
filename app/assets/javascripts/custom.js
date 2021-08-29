function OnLinkClick(target_id) {
  target = document.getElementById(target_id);
  target.style.display = (target.style.display == "none") ? $(target).fadeIn() : $(target).fadeOut();
}

$(function(){
  $('.js-modal-open').each(function(){
    $(this).on('click',function(){
      var target = $(this).data('target');
      var modal = document.getElementById(target);
      $(modal).fadeIn();
      return false;
    });
  });
  $('.js-modal-close').on('click',function(){
    $('.js-modal').fadeOut();
    return false;
  });
});


$(function(){
  $('.js-AccordionMenu').click(function(){
    $(this).next('.header__nav-accordionmenu-window').slideToggle(200);
    $(this).toggleClass("accordionmenu_open");
  });
});


$(document).on('click touchstart', function(event) {
  if (!($(event.target).closest('.header__nav-accordionmenu-window').length || $(event.target).closest('.header__nav-accordionmenu-container').length) && $('.header__nav-accordionmenu-window').css('display') == 'block'){
    $('.js-AccordionMenu').next('.header__nav-accordionmenu-window').slideToggle(200);
    $('.js-AccordionMenu').toggleClass("accordionmenu_open");
  }
});

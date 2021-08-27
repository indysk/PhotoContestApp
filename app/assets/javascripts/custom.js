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

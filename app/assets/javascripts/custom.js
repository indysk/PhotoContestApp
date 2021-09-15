$(function() {

  //モーダルフォーム
  $('.js-modal-open').each(function(){
    $(this).on('click',function(){
      $('#' + this.dataset.target).fadeIn();
      return false;
    });
  });
  $('.js-modal-close').each(function(){
    $(this).on('click',function(){
      $('#' + this.dataset.target).fadeOut();
      return false;
    });
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
  $('#photoFileField').on('change', function() {
    var file = $(this)[0].files[0];
    EXIF.getData(file, function() {
      (artist = EXIF.getTag(this, "Artist")) ? $('#form_photographer').val(artist) : null ;
      $('#form_camera').val(EXIF.getTag(this, "Model"));
      $('#form_lens').val(`${EXIF.getTag(this, "FocalLength")}mm`);
      $('#form_iso').val(EXIF.getTag(this, "ISOSpeedRatings"));
      $('#form_aperture').val(Number(EXIF.getTag(this, "FNumber")).toFixed(1));
      $('#shutter_speed').val(`1/${Math.round(1 / EXIF.getTag(this, "ExposureTime"))}`);
    });
    // img要素に表示
    img_container = $('.photoCreate__form-preview-imgcontainer');
    img_container.css('display') == 'none' ? img_container.css('display', 'block') : null ;
    img_container.children().first().attr('src',window.URL.createObjectURL(file));
  });

  //user画像をプレビューに表示
  $('#userFileField').on('change', function() {
    var file = $(this)[0].files[0];
    // img要素に表示
    img_container = $('.userEdit__form-preview_imgcontainer');
    img_container.css('display') == 'none' ? img_container.css('display', 'block') : null ;
    img_container.children().first().attr('src',window.URL.createObjectURL(file));
  });

  //投票用input制御
  const max_points = Number($('#voting_points').attr('name'));
  const result_DOM = $('#now-voting-points');
  $('.photolist__item-vote_input').each(function(){
    $(this).on('change',function(){
      var sum_points = 0;
      $('.photolist__item-vote_input').each(function(){
        sum_points += Number($(this).val());
      })
      var diff = max_points - sum_points
      result_DOM.text(diff);
      const vote_submit_DOM = $("#vote-submit");
      if(diff >= 0){
        vote_submit_DOM.prop("disabled", false);
        result_DOM.removeClass("danger");
      }else{
        vote_submit_DOM.prop("disabled", true);
        result_DOM.addClass("danger");
      }
    });
  });

  //Contest Formのdatetime入力補助
  //d(日付)_1(募集)_a(開始)
  const DOM_d_1_a = $('#contest_entry_start_at_date');
  const DOM_d_1_b = $('#contest_entry_end_at_date');
  const DOM_d_2_a = $('#contest_vote_start_at_date');
  const DOM_d_2_b = $('#contest_vote_end_at_date');
  const DOM_t_1_a = $('#contest_entry_start_at_time');
  const DOM_t_1_b = $('#contest_entry_end_at_time');
  const DOM_t_2_a = $('#contest_vote_start_at_time');
  const DOM_t_2_b = $('#contest_vote_end_at_time');
  const DOM_date = $('.contestCreate__form-input-date');
  const DOM_time = $('.contestCreate__form-input-time');

  let changed_1_b = false;
  let changed_2_a = false;
  let changed_2_b = false;

  //日付が変更された時
  DOM_date.each(function(){
    $(this).on('change',function(){
      this_value = $(this).val();
      this_date = new Date(this_value).getDate();
      this_id = $(this).attr('id');
      console.log(this_id);

      if(this_id === 'contest_entry_start_at_date'){
        console.log('test');
        changed_1_b ? null : DOM_d_1_b.val(this_value);
      }else if(this_id === 'contest_entry_end_at_date') {
        changed_1_b = true;
        changed_2_a ? null : DOM_d_2_a.val(this_value);
        changed_2_b || changed_2_a ? null : DOM_d_2_b.val(this_value);
      }else if(this_id === 'contest_vote_start_at_date'){
        changed_2_a = true;
        changed_2_b ? null : DOM_d_2_b.val(this_value);
      }else if(this_id === 'contest_vote_end_at_date'){
        changed_2_b = true;
      }
    });
  });
});

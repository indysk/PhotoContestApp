$(function () {

  //モーダルフォーム
  $('.js-modal-open').each(function () {
    $(this).on('click', function () {
      $('#' + this.dataset.target).fadeIn();
      return true;
    });
  });
  $('.js-modal-close').each(function () {
    $(this).on('click', function () {
      $('#' + this.dataset.target).fadeOut();
      return true;
    });
  });


  //補足情報アコーディオン
  $('.js-body-accordion-open').each(function () {
    $(this).on('click', function () {
      $('#' + this.dataset.target).slideToggle(200);
      $('#' + this.dataset.icon).toggleClass("accordion__title-icon_rotate");
      return true;
    });
  });
  $('.js-body-accordion-close').each(function () {
    $(this).on('click', function () {
      $('#' + this.dataset.target).slideToggle(200);
      return true;
    });
  });


  //headerアコーディオンメニュー用
  $('.js-AccordionMenu').click(function () {
    $(this).next('.header__nav-accordionmenu-window').slideToggle(200);
    $(this).toggleClass("accordionmenu_open");
  });
  $(document).on('click touchstart', function (event) {
    if (!($(event.target).closest('.header__nav-accordionmenu-window').length || $(event.target).closest('.header__nav-accordionmenu-container').length) && $('.header__nav-accordionmenu-window').css('display') == 'block') {
      $('.js-AccordionMenu').next('.header__nav-accordionmenu-window').slideToggle(200);
      $('.js-AccordionMenu').toggleClass("accordionmenu_open");
    }
  });


  // ファイルサイズ制限
  const isInFileSizeLimit = (element, file, size = 1) => {
    const sizeLimit = 1024 * 1024 * size;　// 制限サイズ
    if (file.size > sizeLimit) {
      alert(`ファイルサイズは${size}MB以下にしてください`);
      element.value = '';
      return false;
    }
    return true;
  }
  //正方形にリサイズ
  const onImageChange = (file, size) => {
    var TRIM_SIZE = size;
    var canvas = document.createElement('canvas');
    var ctx = canvas.getContext('2d');
    canvas.width = canvas.height = TRIM_SIZE;
    canvas.id = 'canvas-photo';
    var img = new Image();
    img.src = window.URL.createObjectURL(file)
    // imgは読み込んだ後でないとwidth,heightが0
    img.onload = function () {
      // 横長か縦長かで場合分けして描画位置を調整
      var width, height, xOffset, yOffset;
      if (img.width > img.height) {
        height = TRIM_SIZE;
        width = img.width * (TRIM_SIZE / img.height);
        xOffset = -(width - TRIM_SIZE) / 2;
        yOffset = 0;
      } else {
        width = TRIM_SIZE;
        height = img.height * (TRIM_SIZE / img.width);
        yOffset = -(height - TRIM_SIZE) / 2;
        xOffset = 0;
      }
      ctx.drawImage(img, xOffset, yOffset, width, height);
    };
    return canvas;
  }
  //EXIF書き出し
  const writeExifFrom = (file) => {
    EXIF.getData(file, function () {
      $('#form_camera').val(EXIF.getTag(this, "Model"));
      $('#form_lens').val(`${EXIF.getTag(this, "FocalLength")}mm`);
      $('#form_iso').val(EXIF.getTag(this, "ISOSpeedRatings"));
      $('#form_aperture').val(Number(EXIF.getTag(this, "FNumber")).toFixed(1));
      $('#shutter_speed').val(`1/${Math.round(1 / EXIF.getTag(this, "ExposureTime"))}`);
    });
  }
  // img要素に表示
  const displayImgContainer = (file, target) => {
    target.css('display') == 'none' ? target.css('display', 'block') : null;
    target.children().first().attr('src', window.URL.createObjectURL(file));
  }


  //作品応募フォーム、exif取り出し
  $('#photoFileField').on('change', function () {
    var file = $(this)[0].files[0];
    if (!isInFileSizeLimit(this, file, 50)) return;
    writeExifFrom(file);
    displayImgContainer(file, $('.photoCreate__form-preview-imgcontainer'));
  });


  //user画像をプレビューに表示
  $('#userFileField').on('change', function () {
    var file = $(this)[0].files[0];
    if (!isInFileSizeLimit(this, file, 50)) return;
    displayImgContainer(file, $('.userEdit__form-preview_imgcontainer'));
  });


  //投票用input制御
  const max_points = Number($('#voting_points').attr('name'));
  const result_DOM = $('#now-voting-points');
  $('.photolist__item-vote_input').each(function () {
    $(this).on('change', function () {
      var sum_points = 0;
      $('.photolist__item-vote_input').each(function () {
        sum_points += Number($(this).val());
      })
      var diff = max_points - sum_points
      result_DOM.text(diff);
      const vote_submit_DOM = $("#vote-submit");
      if (diff >= 0) {
        vote_submit_DOM.prop("disabled", false);
        result_DOM.removeClass("danger");
      } else {
        vote_submit_DOM.prop("disabled", true);
        result_DOM.addClass("danger");
      }
    });
  });


  // //Contest Formのdatetime入力補助
  // //d(日付)_1(募集)_a(開始)
  // const DOM_d_1_a = $('#contest_entry_start_at_date');
  // const DOM_d_1_b = $('#contest_entry_end_at_date');
  // const DOM_d_2_a = $('#contest_vote_start_at_date');
  // const DOM_d_2_b = $('#contest_vote_end_at_date');
  // const DOM_t_1_a = $('#contest_entry_start_at_time');
  // const DOM_t_1_b = $('#contest_entry_end_at_time');
  // const DOM_t_2_a = $('#contest_vote_start_at_time');
  // const DOM_t_2_b = $('#contest_vote_end_at_time');
  // const DOM_date = $('.contestCreate__form-input-date');
  // const DOM_time = $('.contestCreate__form-input-time');

  // let changed_1_b = false;
  // let changed_2_a = false;
  // let changed_2_b = false;

  // //日付が変更された時
  // DOM_date.each(function(){
  //   $(this).on('change',function(){
  //     this_value = $(this).val();
  //     this_date = new Date(this_value).getDate();
  //     this_id = $(this).attr('id');

  //     if(this_id === 'contest_entry_start_at_date'){
  //       changed_1_b ? null : DOM_d_1_b.val(this_value);
  //     }else if(this_id === 'contest_entry_end_at_date') {
  //       changed_1_b = true;
  //       changed_2_a ? null : DOM_d_2_a.val(this_value);
  //       changed_2_b || changed_2_a ? null : DOM_d_2_b.val(this_value);
  //     }else if(this_id === 'contest_vote_start_at_date'){
  //       changed_2_a = true;
  //       changed_2_b ? null : DOM_d_2_b.val(this_value);
  //     }else if(this_id === 'contest_vote_end_at_date'){
  //       changed_2_b = true;
  //     }
  //   });
  // });


  //URLのコピー処理
  $('.js-url-copy').each(function () {
    $(this).on('click', function () {
      navigator.clipboard.writeText($(this).children('p').text());
    });
  });


  //flashメッセージ表示制御
  function flash_controller() {
    //表示
    if ($('#flash_message').text()) {
      $('#flash_container').css('display', 'block');
      setTimeout(() => {
        $('#flash_container').css('opacity', '1');
        $('#flash_container').css('top', '16px');
      }, 1);
      //閉じるボタン
      $('.js-flash-close').each(function () {
        $(this).on('click', function () {
          $('#flash_container').css('opacity', '0');
          setTimeout(() => {
            $('#flash_container').css('display', 'none');
          }, 400);
        });
      });
      //自動非表示
      setTimeout(() => {
        $('#flash_container').css('opacity', '0');
        $('#flash_container').css('top', '-40px');
        setTimeout(() => {
          $('#flash_container').css('display', 'none');
        }, 400);
      }, 4000);
    }
  }
  let mutationObserver = new MutationObserver(function () { flash_controller() });
  mutationObserver.observe(document.getElementById('flash_container'), { childList: true, subtree: true });
  if ($('#flash_message').text()) { flash_controller() };


  //無限スクロール
  $(document).on('scroll', function () {
    if ($(window).height() + $(document).scrollTop() > $(document).height() - 200) {
      if ($('#loading-target').length && $('#loading-target').css('display') !== 'none') {
        $.ajax({
          type: 'GET',
          dataType: 'script',
          url: $('#loading-target').attr('href')
        })
        $('#loading-target').css('display', 'none');
      }
      if (!$('#loading-icon').length) {
        $('#loading-container').append('<div class="loading-icon" id="loading-icon"></div>')
      }
    }
  })


  //任意のタブにURLからリンクするための設定
  function GethashID (hashIDName){
    if(hashIDName){
      //タブ設定
      $('.tab-links li').find('a').each(function() { //タブ内のaタグ全てを取得
        var idName = $(this).attr('href'); //タブ内のaタグのリンク名（例）#lunchの値を取得
        if(idName == hashIDName){ //リンク元の指定されたURLのハッシュタグ（例）http://example.com/#lunch←この#の値とタブ内のリンク名（例）#lunchが同じかをチェック
          var parentElm = $(this).parent(); //タブ内のaタグの親要素（li）を取得
          $('.tab-links li').removeClass("active"); //タブ内のliについているactiveクラスを取り除き
          $(parentElm).addClass("active"); //リンク元の指定されたURLのハッシュタグとタブ内のリンク名が同じであれば、liにactiveクラスを追加
          //表示させるエリア設定
          $(".tab-body").removeClass("is-active"); //もともとついているis-activeクラスを取り除き
          $(hashIDName).addClass("is-active"); //表示させたいエリアのタブリンク名をクリックしたら、表示エリアにis-activeクラスを追加
        }
      });
    }
  }
  //タブをクリックしたら
  $('.tab-links a').on('click', function() {
    var idName = $(this).attr('href'); //タブ内のリンク名を取得
    GethashID (idName);//設定したタブの読み込みと
    return false;//aタグを無効にする
  });
  // 上記の動きをページが読み込まれたらすぐに動かす
  $(window).on('load', function () {
    $('.tab-links li:first-of-type').addClass("active"); //最初のliにactiveクラスを追加
    $('.tab-body:first-of-type').addClass("is-active"); //最初の.areaにis-activeクラスを追加
    var hashName = location.hash; //リンク元の指定されたURLのハッシュタグを取得
    GethashID (hashName);//設定したタブの読み込み
  });


  //メニュー用
  $('.js-menu').on('click', function() {
    $('#' + this.dataset.menutarget).toggleClass("active");
  });
  $('.js-menu').mouseover(function() {
    $(this).css('opacity', '.8');
	}).mouseout(function() {
    $(this).css('opacity', '1');
	});
  $('.menu.active').mouseover(function(e) {
    $(this).css('background-color', '#eee');
    e.stopPropagation();
  }).mouseout(function(e) {
    e.stopPropagation();
  });
});

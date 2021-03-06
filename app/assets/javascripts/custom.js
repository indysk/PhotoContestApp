$(function () {

    //モーダルフォーム
  $('.js-modal-open').each(function () {
    $(this).on('click', function () {
      const target = $('#' + this.dataset.target);
      const content = target.children('.modal__content');
      const bg = target.children('.modal__bg');

      target.css('display', 'block');
      setTimeout(() => {
        bg.css('opacity', '1');
        content.css('top', '50%');
        content.css('opacity', '1');
        content.css('transform', 'translate(-50%, -50%)');
      }, 1);
      setTimeout(() => {
        content.css('transition', 'cubic-bezier(1, 0.05, 0.6, 0.91) 0.2s')
      }, 200);
      return true;
    });
  });
  $('.js-modal-close').each(function () {
    $(this).on('click', function () {
      const target = $('#' + this.dataset.target);
      const content = target.children('.modal__content');
      const bg = target.children('.modal__bg');

      setTimeout(() => {
        target.css('display', 'none');
        content.css('transition', '')
      }, 200);
      bg.css('opacity', '');
      content.css('top', '');
      content.css('opacity', '');
      content.css('transform', '');
      return true;
    });
  });


  //作品のオリジナルデータをモーダルフォームを開いてから読み込み
  // １．リンク(サムネイル)をクリック
  // ２．クリックした要素のdata属性からオリジナルデータのリンク，オリジナルデータを反映させたい要素のIDを取得
  // ３．反映
  $('.js-load-photo').each(function () {
    $(this).on('click', function () {
      const photoURL = this.dataset.photo_url;
      const photoTarget = this.dataset.photo_target;
      $("#" + photoTarget).attr('src', photoURL);
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
  function isInFileSizeLimit(element, file, size = 1){
    const sizeLimit = 1024 * 1024 * size;　// 制限サイズ
    if (file.size > sizeLimit) {
      alert(`ファイルサイズは${size}MB以下にしてください`);
      element.value = '';
      return false;
    }
    return true;
  }
  //EXIF書き出し
  function writeExifFrom(file){
    EXIF.getData(file, function () {
      function printShutterSpeed(element){
        var ss = EXIF.getTag(element, "ExposureTime");
        if ( ss >= 1 ){
          return `${ss}`
        }else if(ss['numerator'] == 1){
          return `1/${ss['denominator']}`
        }else{
          return `${ss}`
        }
      }
      $('#form_camera').val(EXIF.getTag(this, "Model"));
      $('#form_lens').val(`${EXIF.getTag(this, "FocalLength")}mm`);
      $('#form_iso').val(EXIF.getTag(this, "ISOSpeedRatings"));
      $('#form_aperture').val(Number(EXIF.getTag(this, "FNumber")).toFixed(1));
      // $('#shutter_speed').val(`1/${Math.round(1 / EXIF.getTag(this, "ExposureTime"))}`);
      $('#shutter_speed').val(printShutterSpeed(this));
    });
  }
  // img要素に表示
  function displayImgContainer(file, target){
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
  //ページスクロールをするとajax通信をする
  //タブになっている要素にも適用できる
  $(document).on('scroll', function () {
    //ページ下部であるか
    if ($(window).height() + $(document).scrollTop() > $(document).height() - 200) {
      //トリガーが存在するか確認する
      //次に読み込むものがないとき，トリガーは出力されない
      if ($('.js-loading-trigger').length){
        //トリガーそれぞれについて調べる
        //タブに対応するための処理．アクティブなタブのみ処理を行うようにする．
        $('.js-loading-trigger').each(function(){

          //タブがアクティブであるか
          //トリガー要素の親の親がタブなので，そのdisplayからタブがアクティブであるか調べる
          var parent = $(this).parent().parent()
          //タブではない，またはタブがであり，タブがアクティブであるか
          if(!parent.hasClass('tab') || (parent.hasClass('tab') && parent.css('display') == 'block')){
            //ajax通信
            $.ajax({
              type: 'GET',
              dataType: 'script',
              url: $(this).attr('href'),
            })
            if (!$('.loading-container').length) {
              $(this).after('<div class="loading-container"><div class="loading-icon"></div></div>');
            }
            $(this).remove();
          }
        })
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
          $(".tab").removeClass("is-active"); //もともとついているis-activeクラスを取り除き
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
    $('.tab:first-of-type').addClass("is-active"); //最初の.areaにis-activeクラスを追加
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

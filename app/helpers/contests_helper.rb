module ContestsHelper
  def content_tag_options_for_contest_badge(contest, current_class)
    if contest.is_after_period_voting?
      if contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '1'
        {tag: 'div', content: '非公開', options: {class: "#{current_class} show_result_invisible inactive"}, value: 4.7 }
      elsif contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '0'
        {tag: 'a', content: '投票終了', options: {href: contest_photos_path(contest), class: "#{current_class} vote_finish"}, value: 4.5 }
      elsif contest.visible_range_result.to_s == '0' && contest.visible_range_show.to_s == '1'
        {tag: 'a', content: '投票終了', options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4.3 }
      else
        {tag: 'a', content: '投票終了', options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
      end


    elsif contest.is_in_period_voting?
      if contest.is_already_voted?(current_user)
        {tag: 'div', content: '投票済み', options: {class: "#{current_class} already_voted inactive"}, value: 3.7 }
      elsif contest.visible_range_vote.to_s == '1'
        {tag: 'div', content: '非公開', options: {class: "#{current_class} vote_invisible inactive"}, value: 3.5 }
      else
        {tag: 'a', content: '投票期間中', options: {href: new_contest_vote_path(contest), class: "#{current_class} vote_period"}, value: 3 }
      end


    elsif contest.is_after_period_entry?
      if contest.visible_range_vote.to_s == '1'
        {tag: 'div', content: '非公開', options: {class: "#{current_class} vote_invisible inactive"}, value: 2.5 }
      else
        {tag: 'div', content: '投票準備中', options: {class: "#{current_class} vote_preparing inactive"}, value: 2 }
      end

    elsif contest.is_in_period_entry?
      if contest.is_already_submitted?(current_user)
        {tag: 'a', content: '作品提出済み', options: {href: edit_contest_photo_path(contest, Photo.find_by(contest: contest, user: current_user)), class: "#{current_class} already_entered"}, value: 1.7 }
      elsif contest.visible_range_entry.to_s == '1'
        {tag: 'div', content: '非公開', options: {class: "#{current_class} entry_invisible inactive"}, value: 1.5 }
      else
        {tag: 'a', content: '作品募集中', options: {href: new_contest_photo_path(contest), class: "#{current_class} entry_period"}, value: 1 }
      end


    else
      if contest.visible_range_entry.to_s == '1'
        {tag: 'div', content: '非公開', options: {class: "#{current_class} entry_invisible inactive"}, value: 0.5 }
      else
        {tag: 'div', content: '準備中', options: {class: "#{current_class} entry_preparing inactive"}, value: 0 }
      end
    end
  end

  def content_tag_options_for_contest_links(contest, current_class)
    if contest.is_after_period_voting?
      if contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '1'
        [
          {tag: 'div', content: '作品一覧(非公開)', options: {class: "#{current_class} show_result_invisible inactive photo_list"}, value: 4.5 },
          {tag: 'div', content: '投票結果(非公開)', options: {class: "#{current_class} show_result_invisible inactive"}, value: 4 }
        ]
      elsif contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '0'
        [
          {tag: 'a', content: '作品一覧', options: {href: contest_photos_path(contest), class: "#{current_class} photo_list"}, value: 4.5 },
          {tag: 'div', content: '投票結果(非公開)', options: {class: "#{current_class} show_result_invisible inactive"}, value: 4 }
        ]
      elsif contest.visible_range_result.to_s == '0' && contest.visible_range_show.to_s == '1'
        [
          {tag: 'div', content: '作品一覧(非公開)', options: {class: "#{current_class} show_result_invisible inactive photo_list"}, value: 4.5 },
          {tag: 'a', content: '投票結果', options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
        ]
      else
        [
          {tag: 'a', content: '作品一覧', options: {href: contest_photos_path(contest), class: "#{current_class} photo_list"}, value: 4.5 },
          {tag: 'a', content: '投票結果', options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
        ]
      end


    elsif contest.is_in_period_voting?
      if contest.is_already_voted?(current_user)
        [
          {tag: 'div', content: '投票済み', options: {class: "#{current_class} already_voted inactive"}, value: 3 }
        ]
      elsif contest.visible_range_vote.to_s == '1'
        [
          {tag: 'div', content: '投票ページ(非公開)', options: {class: "#{current_class} vote_invisible inactive"}, value: 3 }
        ]
      else
        [
          {tag: 'a', content: '投票する', options: {href: new_contest_vote_path(contest), class: "#{current_class} vote_finish"}, value: 3 }
        ]
      end


    elsif contest.is_after_period_entry?
      if contest.visible_range_vote.to_s == '1'
        [
          {tag: 'div', content: '投票ページ(非公開)', options: {class: "#{current_class} vote_invisible inactive"}, value: 2 }
        ]
      else
        [
          {tag: 'div', content: '投票ページ(準備中)', options: {class: "#{current_class} vote_invisible inactive"}, value: 2 }
        ]
      end

    elsif contest.is_in_period_entry?
      if contest.is_already_submitted?(current_user)
        [
          {tag: 'a', content: '提出済み[作品を編集する]', options: {href: edit_contest_photo_path(contest, Photo.find_by(contest: contest, user: current_user)), class: "#{current_class} already_entered"}, value: 1 }
        ]
      elsif contest.visible_range_entry.to_s == '1'
        [
          {tag: 'div', content: '作品提出ページ(非公開)', options: {class: "#{current_class} entry_invisible inactive"}, value: 1 }
        ]
      else
        [
          {tag: 'a', content: '作品を提出する', options: {href: new_contest_photo_path(contest), class: "#{current_class} entry_period"}, value: 1 }
        ]
      end


    else
      if contest.visible_range_entry.to_s == '1'
        [
          {tag: 'div', content: '提出ページ(非公開)', options: {class: "#{current_class} entry_preparing"}, value: 0 }
        ]
      else contest.visible_range_entry.to_s == '0'
        [
          {tag: 'div', content: 'コンテスト準備中', options: {class: "#{current_class} entry_preparing"}, value: 0 }
        ]
      end
    end
  end
end

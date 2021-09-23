module ContestsHelper
  def content_tag_options_for_contest_badge(contest, current_class)
    if contest.is_after_period_voting?
      {tag: 'a', content: '投票終了', options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
    elsif contest.is_in_period_voting?
      if contest.is_already_voted?(current_user)
        {tag: 'div', content: '投票済み', options: {class: "#{current_class} already_voted"}, value: 3.5 }
      else
        {tag: 'a', content: '投票期間中', options: {href: contest_photos_path(contest), class: "#{current_class} vote_period"}, value: 3 }
      end
    elsif contest.is_after_period_entry?
      {tag: 'div', content: '投票準備中', options: {class: "#{current_class} vote_preparing"}, value: 2 }
    elsif contest.is_in_period_entry?
      if contest.is_already_submitted?(current_user)
        {tag: 'a', content: '作品提出済み', options: {href: edit_contest_photo_path(contest, Photo.find_by(contest: contest, user: current_user)), class: "#{current_class} already_entered"}, value: 2.5 }
      else
        {tag: 'a', content: '作品募集中', options: {href: new_contest_photo_path(contest), class: "#{current_class} entry_period"}, value: 2 }
      end
    else
      {tag: 'div', content: '準備中', options: {class: "#{current_class} entry_preparing"}, value: 1 }
    end
  end
end

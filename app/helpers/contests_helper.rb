module ContestsHelper
  def content_tag_options_for_contest_badge(contest, current_class)
    if contest.is_after_period_voting?
      {tag: 'a', content: '投票終了', options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4}
    elsif contest.is_in_period_voting?
      {tag: 'a', content: '投票期間中', options: {href: contest_photos_path(contest), class: "#{current_class} vote_finish"}, value: 3}
    elsif contest.is_after_period_entry?
      {tag: 'div', content: '投票準備中', options: {class: "#{current_class} vote_finish"}, value: 2}
    elsif contest.is_in_period_entry?
      {tag: 'a', content: '作品募集中', options: {href: new_contest_photo_path(contest), class: "#{current_class} vote_finish"}, value: 1}
    else
      {tag: 'div', content: '準備中', options: {class: "#{current_class} vote_finish"}, value: 0}
    end
  end
end

module ContestsHelper
  def content_tag_options_for_contest_badge(contest, current_class)
    if contest.is_after_period_voting?
      if contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '1'
        {tag: 'div', content: t('contest.badge.show_result_invisible'), options: {class: "#{current_class} show_result_invisible inactive"}, value: 4.7 }
      elsif contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '0'
        {tag: 'a', content: t('contest.badge.vote_finish'), options: {href: contest_photos_path(contest), class: "#{current_class} vote_finish"}, value: 4.5 }
      elsif contest.visible_range_result.to_s == '0' && contest.visible_range_show.to_s == '1'
        {tag: 'a', content: t('contest.badge.vote_finish'), options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4.3 }
      else
        {tag: 'a', content: t('contest.badge.vote_finish'), options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
      end


    elsif contest.is_in_period_voting?
      if contest.is_already_voted?(current_user)
        {tag: 'div', content: t('contest.badge.already_voted'), options: {class: "#{current_class} already_voted inactive"}, value: 3.7 }
      elsif contest.visible_range_vote.to_s == '1'
        {tag: 'div', content: t('contest.badge.vote_invisible'), options: {class: "#{current_class} vote_invisible inactive"}, value: 3.5 }
      else
        {tag: 'a', content: t('contest.badge.vote_period'), options: {href: new_contest_vote_path(contest), class: "#{current_class} vote_period"}, value: 3 }
      end


    elsif contest.is_after_period_entry?
      if contest.visible_range_vote.to_s == '1'
        {tag: 'div', content: t('contest.badge.vote_invisible'), options: {class: "#{current_class} vote_invisible inactive"}, value: 2.5 }
      else
        {tag: 'div', content: t('contest.badge.vote_preparing'), options: {class: "#{current_class} vote_preparing inactive"}, value: 2 }
      end

    elsif contest.is_in_period_entry?
      if contest.is_already_submitted?(current_user)
        {tag: 'a', content: t('contest.badge.already_entered'), options: {href: edit_contest_photo_path(contest, Photo.find_by(contest: contest, user: current_user)), class: "#{current_class} already_entered"}, value: 1.7 }
      elsif contest.visible_range_entry.to_s == '1'
        {tag: 'div', content: t('contest.badge.entry_invisible'), options: {class: "#{current_class} entry_invisible inactive"}, value: 1.5 }
      else
        {tag: 'a', content: t('contest.badge.entry_period'), options: {href: new_contest_photo_path(contest), class: "#{current_class} entry_period"}, value: 1 }
      end


    else
      if contest.visible_range_entry.to_s == '1'
        {tag: 'div', content: t('contest.badge.entry_invisible'), options: {class: "#{current_class} entry_invisible inactive"}, value: 0.5 }
      else
        {tag: 'div', content: t('contest.badge.entry_preparing'), options: {class: "#{current_class} entry_preparing inactive"}, value: 0 }
      end
    end
  end

  def content_tag_options_for_contest_links(contest, current_class)
    if contest.is_after_period_voting?
      if contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '1'
        [
          {tag: 'div', content: t('contest.links.show_invisible'), options: {class: "#{current_class} show_result_invisible inactive photo_list"}, value: 4.5 },
          {tag: 'div', content: t('contest.links.result_invisible'), options: {class: "#{current_class} show_result_invisible inactive"}, value: 4 }
        ]
      elsif contest.visible_range_result.to_s == '1' && contest.visible_range_show.to_s == '0'
        [
          {tag: 'a', content: t('contest.links.show'), options: {href: contest_photos_path(contest), class: "#{current_class} photo_list"}, value: 4.5 },
          {tag: 'div', content: t('contest.links.result_invisible'), options: {class: "#{current_class} show_result_invisible inactive"}, value: 4 }
        ]
      elsif contest.visible_range_result.to_s == '0' && contest.visible_range_show.to_s == '1'
        [
          {tag: 'div', content: t('contest.links.show_invisible'), options: {class: "#{current_class} show_result_invisible inactive photo_list"}, value: 4.5 },
          {tag: 'a', content: t('contest.links.result'), options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
        ]
      else
        [
          {tag: 'a', content: t('contest.links.show'), options: {href: contest_photos_path(contest), class: "#{current_class} photo_list"}, value: 4.5 },
          {tag: 'a', content: t('contest.links.result'), options: {href: contest_votes_path(contest), class: "#{current_class} vote_finish"}, value: 4 }
        ]
      end


    elsif contest.is_in_period_voting?
      if contest.is_already_voted?(current_user)
        [
          {tag: 'div', content: t('contest.links.already_voted'), options: {class: "#{current_class} already_voted inactive"}, value: 3 }
        ]
      elsif contest.visible_range_vote.to_s == '1'
        [
          {tag: 'div', content: t('contest.links.vote_invisible'), options: {class: "#{current_class} vote_invisible inactive"}, value: 3 }
        ]
      else
        [
          {tag: 'a', content: t('contest.links.vote'), options: {href: new_contest_vote_path(contest), class: "#{current_class} vote"}, value: 3 }
        ]
      end


    elsif contest.is_after_period_entry?
      if contest.visible_range_vote.to_s == '1'
        [
          {tag: 'div', content: t('contest.links.vote_invisible'), options: {class: "#{current_class} vote_invisible inactive"}, value: 2 }
        ]
      else
        [
          {tag: 'div', content: t('contest.links.vote_prepering'), options: {class: "#{current_class} vote_prepering inactive"}, value: 2 }
        ]
      end

    elsif contest.is_in_period_entry?
      if contest.is_already_submitted?(current_user)
        [
          {tag: 'a', content: t('contest.links.already_entered'), options: {href: edit_contest_photo_path(contest, Photo.find_by(contest: contest, user: current_user)), class: "#{current_class} already_entered"}, value: 1 }
        ]
      elsif contest.visible_range_entry.to_s == '1'
        [
          {tag: 'div', content: t('contest.links.entry_invisible'), options: {class: "#{current_class} entry_invisible inactive"}, value: 1 }
        ]
      else
        [
          {tag: 'a', content: t('contest.links.entry'), options: {href: new_contest_photo_path(contest), class: "#{current_class} entry_period"}, value: 1 }
        ]
      end


    else
      if contest.visible_range_entry.to_s == '1'
        [
          {tag: 'div', content: t('contest.links.entry_invisible'), options: {class: "#{current_class} entry_invisible inactive"}, value: 0 }
        ]
      else contest.visible_range_entry.to_s == '0'
        [
          {tag: 'div', content: t('contest.links.entry_preparing'), options: {class: "#{current_class} entry_preparing inactive"}, value: 0 }
        ]
      end
    end
  end
end

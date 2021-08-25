module ContestsHelper
  def photo_overview_about(contest)
    if(photo = contest.photos.first)
      photo.image
    else
      print_default_img
    end
  end

end

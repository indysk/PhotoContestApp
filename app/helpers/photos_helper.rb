module PhotosHelper
  def path_for_photo_show(photo)
    user_or_contest_id = params[:id]
    photo_id = photo.id
    return user_photo_path(user_or_contest_id, photo_id) if(current_page?(user_path(user_or_contest_id)) || current_page?(user_photo_path(user_or_contest_id, photo_id)))
    return contest_photo_path(user_or_contest_id, photo_id) if(current_page?(contest_path(user_or_contest_id)) || current_page?(contest_photo_path(user_or_contest_id, photo_id)))
  end
end

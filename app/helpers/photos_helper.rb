module PhotosHelper
  def path_for_photo(photo)
    user_or_contest_id = params[:id] || params[:contest_id]
    photo_id = photo.id
    return user_photo_path(user_or_contest_id, photo_id) if(current_page?(user_path(user_or_contest_id)) || current_page?(user_photo_path(user_or_contest_id, photo_id)))
    return contest_photo_path(user_or_contest_id, photo_id) if(current_page?(contest_photos_path(user_or_contest_id)) || current_page?(contest_photo_path(user_or_contest_id, photo_id)) || current_page?(contest_votes_path(user_or_contest_id)))
  end

  def path_for_redirect_from_photo_delete
    return contest_path(params[:contest_id]) if params[:contest_id].present?
    return user_path(params[:user_id]) if params[:user_id].present?
  end
end

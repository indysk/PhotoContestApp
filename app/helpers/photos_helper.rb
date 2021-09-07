module PhotosHelper
  def path_for_photo(photo, method = nil)
    if @model_for_path.nil?
      user_or_contest_id = params[:contest_id] || params[:user_id] || params[:id]
      model = Contest.find_by(id: user_or_contest_id) || User.find_by(id: user_or_contest_id)
      @model_for_path = {class: model.class.to_s, id: user_or_contest_id}
    end

    if method.nil?
      return contest_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'Contest'
      return user_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'User'
    elsif method == 'edit'
      return edit_contest_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'Contest'
      return edit_user_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'User'
    elsif method == 'new'
      return edit_contest_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'Contest'
      return edit_user_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'User'
    elsif method == 'form'
      return contest_photos_path(@model_for_path[:id]) if !photo.id.present?
      return contest_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'Contest'
      return user_photo_path(@model_for_path[:id], photo.id) if @model_for_path[:class] == 'User'
    end
  end

  def path_for_redirect_from_photo_delete
    return contest_path(params[:contest_id]) if params[:contest_id].present?
    return user_path(params[:user_id]) if params[:user_id].present?
  end
end

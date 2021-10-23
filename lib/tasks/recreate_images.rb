Photo.all.each do |model|
  begin
    p model.id
    if model.image.present?
      model.image.recreate_versions!
      model.save!
    end
  rescue
    p "#{model.id} recreate failed."
  end
end

# rails runner lib/tasks/recreate_images.rb
Photo.all.each do |model|
  begin
    p model.id
    if model.image.present?
      if model.image.thumb.present?
        p "#{model.id} already recreated."
        next
      end
      model.image.recreate_versions!
      p "#{model.id} successed." if model.save!
    end
  rescue
    p "#{model.id} recreate failed."
  end
end

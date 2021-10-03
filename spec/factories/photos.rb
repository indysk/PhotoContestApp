FactoryBot.define do
  factory :photo, class: Photo do
    name          { "Photo_Name" }
    association   :contest, factory: :contest
    association   :user, factory: :user
    description   { "photo description" }
    camera        { "camera" }
    lens          { "lens 50mm" }
    iso           { "400" }
    aperture      { "f2.0" }
    shutter_speed { "1/1600" }
    image         { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/sample.JPG')) }
  end

  factory :other_photo, class: Photo do
    name          { "Other_Photo_Name" }
    association   :contest, factory: :contest
    association   :user, factory: :user
    description   { "photo description" }
    camera        { "camera" }
    lens          { "lens 50mm" }
    iso           { "400" }
    aperture      { "f2.0" }
    shutter_speed { "1/1600" }
    image         { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/sample.JPG')) }
  end

  factory :japanese_photo, class: Photo do
    name          { "日本語の作品" }
    association   :contest, factory: :contest
    association   :user, factory: :user
    description   { "作品の説明" }
    camera        { "キャノンのカメラ" }
    lens          { "レンズ５０単" }
    iso           { "400" }
    aperture      { "f2.0" }
    shutter_speed { "1/1600" }
    image         { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/sample.JPG')) }
  end
end

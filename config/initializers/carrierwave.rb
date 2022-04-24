unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.S3_photocon[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.S3_photocon[:secret_access_key],
      region: 'ap-northeast-1'
    }

    config.fog_directory = Rails.application.credentials.S3_photocon[:bucket]
    config.cache_storage = :fog
    config.fog_public = false
    config.fog_authenticated_url_expiration = 2.hours.to_i
  end
end

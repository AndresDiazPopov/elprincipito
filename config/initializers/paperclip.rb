if ENV["s3_active"] == "true"

  Paperclip::Attachment.default_options.merge!({
    storage: :s3,
    s3_credentials: {
      bucket: ENV["s3_bucket_name"],
      access_key_id: ENV["s3_access_key"],
      secret_access_key: ENV["s3_access_secret"],
      s3_region: ENV["s3_region"]
    },
    s3_protocol: ENV["s3_protocol"]
  })

  Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
  Paperclip::Attachment.default_options[:path] = '/:class/:id/:style.:extension'

else

  Paperclip::Attachment.default_options[:url] = '/system/:rails_env/:class/:id/:style.:extension'
  Paperclip::Attachment.default_options[:path] = ':rails_root/public/system/:rails_env/:class/:id/:style.:extension'
  
end

class Paperclip::Deprecations
  if Paperclip::VERSION < '5'
    def self.warn_aws_sdk_v1
    end
  end
end
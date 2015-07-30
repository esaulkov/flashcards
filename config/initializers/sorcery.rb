Rails.application.config.sorcery.submodules = [:remember_me, :reset_password]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.reset_password_mailer = UserMailer

    # -- external --
    # user.authentications_class =

    # user.authentications_user_id_attribute_name =

    # user.provider_attribute_name =

    # user.provider_uid_attribute_name =
  end

  config.user_class = "User"
end

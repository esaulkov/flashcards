Rails.application.config.sorcery.submodules = []

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  # -- core --
  # config.not_authenticated_action =

  # config.save_return_to_url =

  # config.cookie_domain =

  # config.remember_me_httponly =

  # config.session_timeout =

  # config.session_timeout_from_last_action =

  # config.controller_to_realm_map =

  # config.register_login_time =

  # config.register_logout_time =

  # config.register_last_activity_time =

  # config.external_providers =

  # config.ca_file =

  # --- user config ---
  config.user_config do |user|
    # -- core --
    # user.username_attribute_names =

    # user.password_attribute_name =

    # user.downcase_username_before_authenticating =

    # user.email_attribute_name =

    # user.crypted_password_attribute_name =

    # user.salt_join_token =

    # user.salt_attribute_name =

    # user.stretches =

    # user.encryption_key =

    # user.custom_encryption_provider =

    # user.encryption_algorithm =

    # user.subclasses_inherit_config =

    # -- remember_me --
    # user.remember_me_for =

    # -- user_activation --
    # user.activation_state_attribute_name =

    # user.activation_token_attribute_name =

    # user.activation_token_expires_at_attribute_name =

    # user.activation_token_expiration_period =

    # user.user_activation_mailer =

    # user.activation_mailer_disabled =

    # user.activation_needed_email_method_name =

    # user.activation_success_email_method_name =

    # user.prevent_non_active_users_to_login =

    # -- reset_password --
    # user.reset_password_token_attribute_name =

    # user.reset_password_token_expires_at_attribute_name =

    # user.reset_password_email_sent_at_attribute_name =

    # user.reset_password_mailer =

    # user.reset_password_email_method_name =

    # user.reset_password_mailer_disabled =

    # user.reset_password_expiration_period =

    # user.reset_password_time_between_emails =

    # -- brute_force_protection --
    # user.failed_logins_count_attribute_name =

    # user.lock_expires_at_attribute_name =

    # user.consecutive_login_retries_amount_limit =

    # user.login_lock_time_period =

    # user.unlock_token_attribute_name =

    # user.unlock_token_email_method_name =

    # user.unlock_token_mailer_disabled = true

    # user.unlock_token_mailer = UserMailer

    # -- activity logging --
    # user.last_login_at_attribute_name =

    # user.last_logout_at_attribute_name =

    # user.last_activity_at_attribute_name =

    # user.activity_timeout =

    # -- external --
    # user.authentications_class =

    # user.authentications_user_id_attribute_name =

    # user.provider_attribute_name =

    # user.provider_uid_attribute_name =
  end

  config.user_class = "User"
end

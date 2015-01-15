SanitizeEmail::Config.configure do |config|
  config[:sanitized_to] = 'montylennie@gmail.com'
  config[:sanitized_cc] = 'montylennie@gmail.com'
  config[:sanitized_bcc] = 'montylennie@gmail.com'
  # run/call whatever logic should turn sanitize_email on and off in this Proc:
  config[:activation_proc] =      Proc.new { %w(staging).include?(Rails.env) }
  config[:use_actual_email_prepended_to_subject] = true         # or false
  config[:use_actual_environment_prepended_to_subject] = true   # or false
  config[:use_actual_email_as_sanitized_user_name] = true       # or false
end
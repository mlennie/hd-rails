class ApplicationController < ActionController::Base
  before_filter :authenticate_user_from_token!
  before_filter :set_mixpanel_variable

  private

    def authenticate_user_from_token!
      authenticate_with_http_token do |token, options|
        user_email = options[:user_email].presence
        user       = user_email && User.find_by_email(user_email)

        if user && Devise.secure_compare(user.authentication_token, token)
          sign_in user, store: false
        end
      end
    end

    def set_mixpanel_variable
      @tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_CODE'])
    end
end

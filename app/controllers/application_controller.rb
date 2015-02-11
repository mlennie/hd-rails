class ApplicationController < ActionController::Base
  before_filter :add_allow_credentials_headers
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

    def add_allow_credentials_headers                                                                                                                                                                                                                                                        
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5                                                                                                                                                                                                      
      #                                                                                                                                                                                                                                                                                       
      # Because we want our front-end to send cookies to allow the API to be authenticated                                                                                                                                                                                                   
      # (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so                                                                                                                                                                                                      
      # the browser will not reject the response                                                                                                                                                                                                                                             
      response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'                                                                                                                                                                                                     
      response.headers['Access-Control-Allow-Credentials'] = 'true'                                                                                                                                                                                                                          
    end 

    def options                                                                                                                                                                                                                                                                              
      head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'                                                                                                                                                                                                         
    end

    def set_mixpanel_variable
      @tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_CODE'])
    end
end

class SessionsController < Devise::SessionsController
  def create
    respond_to do |format|
      format.html { super }
      format.json do
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        data = {
          user_token: self.resource.authentication_token,
          user_email: self.resource.email,
          user_id: self.resource.id,
          is_owner: self.resource.restaurants.any? ? true : false
        }
        render json: data, status: 201
      end
    end
  end
end
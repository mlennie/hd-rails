class ServicesController < ApplicationController
	
	#GET /services?restaurant_id=:id
	def index
		if user_signed_in?
			if (restaurant = Restaurant.find(params[:restaurant_id]))
				services = restaurant.services.get_unarchived
				render json: services, status: 200
			else
				head 422
			end
		else
			head 401
		end
	end

	def update
    if user_signed_in?
      #check to make sure user is owner and service belongs to
      #owner then update if it is
      if Service.check_and_update(current_user.id, params)
        head 204
      else
        head 422
      end
    else
      head 401
    end
  end
end
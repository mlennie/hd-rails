class ServicesController < ApplicationController
	
	#GET /services?restaurant_id=:id
	def index
		if user_signed_in?
			if (restaurant = Restaurant.find(params[:restaurant_id]))
				#if this is for an owner, don't get more than needed
				if restaurant.user == current_user
					services = restaurant.services.get_unarchived.future_with_availabilities.first(30)
				else
					services = restaurant.services.get_unarchived.future_with_availabilities
				end
				render json: services
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
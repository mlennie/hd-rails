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
end
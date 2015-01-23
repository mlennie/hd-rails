class RestaurantsController < ApplicationController

	def index 
		restaurants = Restaurant.includes(:services, :cuisines).get_unarchived
		render json: restaurants, status: 200
	end

end

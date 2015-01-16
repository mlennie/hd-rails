class RestaurantsController < ApplicationController

	def index 
		restaurants = Restaurant.includes(:cuisines).all
		render json: restaurants
	end
end

class RestaurantsController < ApplicationController

	def index 
		restaurants = Restaurant.includes(menus: :menu_items).all
		render json: restaurants
	end
end

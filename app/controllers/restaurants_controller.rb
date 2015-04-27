class RestaurantsController < ApplicationController

	def index 
		restaurants = Restaurant.includes(:services, :cuisines, menus: :menu_items).get_unarchived
		render json: restaurants, status: 200
	end

	def show 
		restaurant = Restaurant.includes(:services, menus: :menu_items).where(id: params[:id]);
		render json: restaurant, 
								 status: 200, 
								 each_serializer: ShowPageRestaurantSerializer,
								 root: 'restaurants'
	end

end

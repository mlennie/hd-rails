class RestaurantsController < ApplicationController

	def index 
		#check if request has date, time and ids (meaning that it is coming from 
		#search.js for a search request)
		if params[:ids].present?
			
			restaurant_ids = Restaurant.filter_restaurants_by_search_params params

			#return json
			render json: {restaurant_ids: restaurant_ids}, status: 200
		else
			restaurants = Restaurant.includes(:services, :cuisines, menus: :menu_items).get_unarchived
			render json: restaurants, status: 200
		end
	end

	def show 
		restaurant = Restaurant.includes(:services, menus: :menu_items).where(id: params[:id]);
		render json: restaurant, 
								 status: 200, 
								 each_serializer: ShowPageRestaurantSerializer,
								 root: 'restaurants'
	end

end

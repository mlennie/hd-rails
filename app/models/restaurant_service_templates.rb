class RestaurantServiceTemplates < ActiveRecord::Base
	belongs_to :service
	belongs_to :restaurant
end

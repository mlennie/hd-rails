class ServiceTemplate < ActiveRecord::Base

	include Archiving

	has_many :services
	has_many :restaurant_service_templates
	has_many :restaurants, through: :restaurant_service_templates
end

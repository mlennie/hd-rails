class ServiceTemplate < ActiveRecord::Base

	include Archiving

	has_many :services
	belongs_to :restaurant
end

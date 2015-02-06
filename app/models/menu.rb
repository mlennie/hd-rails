class Menu < ActiveRecord::Base
	include Archiving

	belongs_to :restaurant

	validates_presence_of :restaurant_id

	enum status: [ :entree, :principaux, :dessert ]
end

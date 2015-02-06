class Menu < ActiveRecord::Base
	include Archiving

	belongs_to :restaurant

	enum status: [ :entree, :principaux, :dessert ]
end

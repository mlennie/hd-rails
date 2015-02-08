class Menu < ActiveRecord::Base
	include Archiving

	belongs_to :restaurant
	has_many :menu_items

	validates_presence_of :restaurant_id, :name, :title, :kind

	enum kind: [ :complete, :a_la_carte ]
end

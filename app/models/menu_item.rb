class MenuItem < ActiveRecord::Base
	include Archiving

	belongs_to :menu

	validates_presence_of :course, :name, :menu_id

	enum course: [ :Hors_doeuvre, :entree, :principaux, :dessert, :boisson ]
end

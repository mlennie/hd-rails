class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode, :street, :city,
  					 :latitude, :longitude
  
  has_many :cuisines
	has_many :services
	has_many :menus

  def services
  	self.services.future_with_availabilities.get_unarchived
  end

  def cuisines
  	self.cuisines.get_unarchived
  end

  def menus
    self.menus.get_unarchived
  end
end

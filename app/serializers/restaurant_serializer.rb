class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode, :street, :city,
  					 :latitude, :longitude
  
  has_many :cuisines
	has_many :services
	has_many :menus

  def services
  	object.services.get_unarchived.future_with_availabilities
  end

  def cuisines
  	object.cuisines.get_unarchived
  end

  def menus
    object.menus.get_unarchived
  end
end

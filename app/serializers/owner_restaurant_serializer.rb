class OwnerRestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode, :street, :city,
  					 :latitude, :longitude
  
  has_many :services

  def services
  	object.services.get_unarchived.future_with_availabilities
  end
end

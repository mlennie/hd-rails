class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode, :street, :city
  has_many :cuisines
  has_many :services

  def services
  	object.services.future_with_availabilities
  end
end

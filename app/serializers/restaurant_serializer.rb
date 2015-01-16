class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode, :street, :city
  has_many :cuisines
end

class RestaurantsSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode
  embed :id
end

class RestaurantsSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description
end

class MenuSerializer < ActiveModel::Serializer
  attributes :id, :restaurant_id, :name, :title, :description, :kind, :price
  has_many :menu_items
end

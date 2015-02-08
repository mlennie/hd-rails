class MenuItemSerializer < ActiveModel::Serializer
  attributes :id, :menu_id, :course, :name, :description, :price
end

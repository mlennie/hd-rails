class MenuSerializer < ActiveModel::Serializer
  attributes :id, :restaurant_id, :name, :title, :description, 
  					 :kind, :price
  
  has_many :menu_items

  def menu_items
    MenuItem.where(menu_id: self.id).get_unarchived
  end
end

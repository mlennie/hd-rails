class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :description, :zipcode, :street, :city
  has_many :menus

  def menus
    Menu.where(restaurant_id: self.id).get_unarchived
  end
end

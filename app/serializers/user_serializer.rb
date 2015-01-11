class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email
  has_one :wallet
  has_many :roles
  has_many :restaurants
end

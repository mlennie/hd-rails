class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email

  has_one :wallet

  embed :ids, :include => true
end

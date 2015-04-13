class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :referral_code, :gender, :balance
  has_one :wallet
  has_many :roles
  has_many :restaurants
  has_many :reservations

  def reservations
    Reservation.where(user_id: self.id).get_unarchived
  end

  def balance
  	if self.restaurants.any?
  		return self.restaurants.first.wallet.balance
  	end
  end
end

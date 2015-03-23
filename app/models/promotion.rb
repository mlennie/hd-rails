class Promotion < ActiveRecord::Base

	include Archiving

  has_many :user_promotions
  has_many :users, through: :user_promotions
  has_many :reservations, through: :user_promotions
  has_many :transactions, as: :itemable

  validates_presence_of :code, :description, :amount

  def self.apply_to user, code
  	ActiveRecord::Base.transaction do 
      promotion = Promotion.find_by(code: code)

      if promotion
  	  	#create transaction and update wallet balance
  	  	Transaction.create_promotional_transaction user, promotion

  	  	#update promotion times used 
  	  	times_used = 0 if times_used.nil?
  	  	promotion.update(times_used: times_used += 1)
      end
	  end
  end
end

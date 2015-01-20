class Promotion < ActiveRecord::Base

	include Archiving

  has_many :user_promotions
  has_many :users, through: :user_promotions
  has_many :reservations, through: :user_promotions
  has_many :transactions, as: :itemable

  validates_presence_of :code, :description, :amount

  #check to see if promotion returns and return it if it does
  def self.check_presence params
    if params[:user][:promotionCode].present?
      return Promotion.find(code: params[:user][:promotionCode])
    else
    	return nil
    end
  end

  def apply_to user
  	ActiveRecord::Base.transaction do 

	  	#create transaction and update wallet balance
	  	Transaction.create_promotional_transaction user, self

	  	#update promotion times used 
	  	self.update(times_used: times_used += 1)
	  	
	  end
  end
end

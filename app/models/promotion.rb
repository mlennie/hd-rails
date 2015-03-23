class Promotion < ActiveRecord::Base

	include Archiving

  has_many :user_promotions
  has_many :users, through: :user_promotions
  has_many :reservations, through: :user_promotions
  has_many :transactions, as: :itemable

  validates_presence_of :code, :description, :amount

  #check to see if promotion returns and return it if it does
  def self.check_presence params
    if params[:user][:promotion_code].present?
      promotion = Promotion.find_by(code: params[:user][:promotion_code])
      if promotion 
        return promotion
      else
        return "bad code"
      end
    else
    	return nil
    end
  end

  def apply_to user
  	ActiveRecord::Base.transaction do 

	  	#create transaction and update wallet balance
	  	Transaction.create_promotional_transaction user, self

	  	#update promotion times used 
	  	times_used = 0 if times_used.nil?
	  	self.update(times_used: times_used += 1)

	  end
  end
end

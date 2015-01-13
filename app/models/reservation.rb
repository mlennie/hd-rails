class Reservation < ActiveRecord::Base

  include Archiving

  enum status: [ :not_viewed, :viewed, :cancelled, :validated, :finished ]

  belongs_to :user
  belongs_to :restaurant
  belongs_to :service
  has_one :rating
  has_many :reservation_errors
  has_many :user_promotions
  has_many :promotions, through: :user_promotions
  has_many :transactions, as: :itemable

  before_save :add_confirmation

  just_define_datetime_picker :time

  validates_presence_of :nb_people, :time, :restaurant_id, :user_id, 
                        :discount, :booking_name

  def add_confirmation
    confirmation = generate_confirmation
    self.confirmation = confirmation
  end

  def create_transactions params
    #add transaction so that both transaction updates need to be successful
    #or else everything does a rollback
    ActiveRecord::Base.transaction do 
      self.restaurant.create_reservation_transaction(
        params[:bill_amount] discount user_contribution self
      )
      self.user.create_reservation_transaction(
        params[:bill_amount] discount user_contribution self
      )
    end
  end

  private

  def generate_confirmation
    loop do
      token = SecureRandom.hex[0,8]
      break token unless Reservation.where(confirmation: token).first
    end
  end
end

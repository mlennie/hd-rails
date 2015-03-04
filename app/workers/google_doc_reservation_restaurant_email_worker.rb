class GoogleDocReservationRestaurantEmailWorker
  include Sidekiq::Worker

  def perform
    10.times do 
    	puts "long name sidekiq worked"
    end
  end
end
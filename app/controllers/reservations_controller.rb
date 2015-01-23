class ReservationsController < ApplicationController

  def create
    #build reservation
    reservation = Reservation.new(reservation_params)

    #save reservation
    if reservation.save!
      render json: reservation, status: 201
    else
      render json: reservation.errors, status: 422
    end
  end

  private
  
    def reservation_params
      params.require(:reservation).permit(
        :nb_people, :time, :status, :restaurant_id, 
        :user_id, :service_id, :discount, :user_contribution,
        :booking_name, :status
      )
    end
end
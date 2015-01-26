class ReservationsController < ApplicationController

  def create
    if user_signed_in? && 
      current_user.id == params[:reservation][:user_id].to_i

      #get service id
      params[:reservation][:service_id] = Service.get_service_id params

      #build reservation
      reservation = Reservation.new(reservation_params)

      #save reservation
      if reservation.save!
        render json: reservation, status: 201
      else
        render json: reservation.errors, status: 422
      end
    else
      head 401
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
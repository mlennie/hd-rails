class ReservationsController < ApplicationController

  def index
    if user_signed_in? && current_user.is_owner?
      if params[:finished]
        reservations = current_user.owner_reservations.finished
      else
        reservations = current_user.owner_reservations.in_progress
      end
      render json: reservations, 
             status: 200,
             owner: true , 
             each_serializer: OwnerReservationsSerializer
    else
      head 401
    end
  end

  def create
    if user_signed_in? && 
      current_user.id == params[:reservation][:user_id].to_i

      #get service
      service = Service.get_service params

      #make sure discount is up to date
      #if not, send back error message with updated discount
      if service && service.current_discount == params[:reservation][:discount] &&
         service.current_discount > 0
        #get service id
        params[:reservation][:service_id] = service.id

        #build reservation
        reservation = Reservation.new(reservation_params)

        #save reservation
        if reservation.save
          render json: reservation, status: 201
        else
          render json: reservation.errors, status: 422
        end
      else
        render json: { errors: 
                        {
                          discount: service.current_discount
                        } 
                      }, status: 422
      end
    else
      head 401
    end
  end

  def update
    if user_signed_in?
      #check to make sure user is owner and reservation is 
      #owner's reservation then update if it is
      if Reservation.check_and_update(current_user.id, params)
        head 204
      else
        head 422
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
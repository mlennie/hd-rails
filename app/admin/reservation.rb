ActiveAdmin.register Reservation do
  permit_params :confirmation, :nb_people, :time, :status, :viewed_at,
                :cancelled_at, :validated_at, :absent_at, :finalized_at,
                :restaurant_id, :restaurant, :user_id, :service_id, :bill_amount,
                :user_balance, :restaurant_balance, :discount,
                :user_contribution, :booking_name, :time_date, :time_time_hour,
                :time_time_minute

  belongs_to :restaurant, optional: true
  belongs_to :user, optional: true

  controller do
    def scoped_collection
      if params[:user_id]
        restaurant_id = Restaurant.where(user_id: params[:user_id])
        Reservation.where(restaurant_id: restaurant_id).get_unarchived
      else
        Reservation.get_unarchived
      end
    end

    def create
      #if created reservation through a user (if params[:user_id] present)
      #then move it within reservation param (like if admin when to new 
      #reservation page directly and selected a user)
      if params[:user_id]
        params[:reservation][:user_id] = params[:user_id]
        params.delete(:user_id)
      end

      if params[:reservation][:user_contribution].empty?
        params[:reservation][:user_contribution] = "0" 
      else
        #make sure user has enough money to spend this amount
        unless User.find(params[:reservation][:user_id]).check_contribution(params[:reservation][:user_contribution].to_f)
          flash[:danger] = "User does not have enough to spend this amount."
          return redirect_to new_admin_user_reservation_path(User.find(params[:reservation][:user_id]))
        end
      end

      #get reservation time
      date_array = params[:reservation][:time_date].split('-')
      year = date_array[0]
      month = date_array[1]
      day = date_array[2]
      hour = params[:reservation][:time_time_hour]
      minutes = params[:reservation][:time_time_minute]
      reservation_time = Time.zone.local(year,month,day,hour,minutes)

      #get service and check that there are still availabilities 
      #and discounts available
      params[:reservation][:time] = reservation_time
      service = Service.get_service params
      params[:reservation].delete(:time)

      if service && service.current_discount > 0
        params[:reservation][:service_id] = service.id
        #set discount from service's current discount
        #unless user uses their euros (user_contribution is not 0)
        
        if params[:reservation][:user_contribution] == "0" 
          params[:reservation][:discount] = service.current_discount
        else
          params[:reservation][:discount] = 0.0
        end
        super
      else
        flash[:danger] = "Could not find service with availabilities during selected times"
        redirect_to new_admin_user_reservation_path(User.find(params[:reservation][:user_id]))
      end
    end

    def update
      reservation = Reservation.find(params[:id])
      if reservation.transactions_should_be_created? params
        if reservation.create_transactions_and_update_reservation params
          super
        else
          flash[:warning] = 'reservation and balances could not be updated'
          redirect_to edit_admin_reservation_path(reservation)
        end
      elsif reservation.transactions_should_be_reset? params
        if reservation.update_transactions_and_wallets params
          super
        else
          flash[:warning] = 'reservation and balances could not be updated'
          redirect_to edit_admin_reservation_path(reservation)
        end
      else
        super
      end
    end

    def destroy
      #do nothing for now
    end
  end

  index do
    selectable_column
    id_column
    column :confirmation
    column :nb_people
    column :time
    column :status
    column :viewed_at
    column :cancelled_at
    column :validated_at
    column :absent_at
    column :finalized_at
    column :restaurant_id
    column :user_id
    column :service_id
    column :bill_amount
    column :user_balance
    column :restaurant_balance
    column(:discount) do |reservation|
      (reservation.discount * 100).round.to_s + '%' rescue nil
    end
    column :user_contribution
    column :booking_name
    column :created_at
    column :updated_at
    actions
 end

  filter :confirmation
  filter :nb_people
  filter :time
  filter :status
  filter :viewed_at
  filter :cancelled_at
  filter :validated_at
  filter :absent_at
  filter :finalized_at
  filter :restaurant_id
  filter :user_id
  filter :service_id
  filter :bill_amount
  filter :user_balance
  filter :restaurant_balance
  filter :discount, :as => :select, 
          :collection => [['10%', 0.10], ['15%', 0.15], ['20%', 0.20],
          ['25%', 0.25], ['30%', 0.30]]
  filter :user_contribution
  filter :booking_name
  filter :created_at
  filter :updated_at

  form do |f|

   if User.exists_and_has_names? params
      user = User.find(params[:user_id])
      for_user = user.first_name + ' ' + user.last_name
    else
      for_user = "for user with no name yet"
    end
    f.inputs "New reservation #{for_user}" do
      f.input :nb_people
      f.input :time, :as => :just_datetime_picker
      if f.object.new_record?
        f.input :restaurant, required: true
        unless params[:user_id].present?
          f.input :user
        end
      end
      #f.input :service_id
      unless f.object.new_record? 
        f.input :discount, :as => :select, 
              :collection => [['0%',0.0], ['10%', 0.10], ['15%', 0.15], ['20%', 0.20],
              ['25%', 0.25], ['30%', 0.30]]
      end
      f.input :user_contribution
      f.input :booking_name
      if !f.object.new_record?
        f.input :bill_amount
        f.input :status, :as => :select, 
                :collection => ['pending_confirmation', 'validated', 'absent', 'cancelled']
        f.input :viewed_at
        f.input :cancelled_at
        f.input :validated_at
        f.input :absent_at
        f.input :finalized_at
      end
    end
    f.actions
  end
end

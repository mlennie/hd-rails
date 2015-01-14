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
      Reservation.get_unarchived
    end

    def create
      params[:reservation][:user_id] = params[:user_id]
      super
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
      r = Reservation.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_reservations_path
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
    if params[:user_id].present?
      user = User.find(params[:user_id])
      for_user = user.first_name + ' ' + user.last_name
    else
      for_user = ""
    end
    f.inputs "New reservation #{for_user}" do
      f.input :nb_people
      f.input :time, :as => :just_datetime_picker
      f.input :status, :as => :select, :collection => ['not_viewed', 'viewed',
              'cancelled', 'validated', 'finished']
      f.input :viewed_at
      f.input :cancelled_at
      f.input :validated_at
      f.input :absent_at
      f.input :finalized_at
      f.input :restaurant, required: true
      unless params[:user_id].present?
        f.input :user
      end
      f.input :service_id
      f.input :bill_amount
      f.input :discount, :as => :select, 
              :collection => [['0%',0], ['10%', 0.10], ['15%', 0.15], ['20%', 0.20],
              ['25%', 0.25], ['30%', 0.30]]
      f.input :user_contribution
      f.input :booking_name
    end
    f.actions
 end
end

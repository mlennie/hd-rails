ActiveAdmin.register Reservation do
  permit_params :confirmation, :nb_people, :time, :status, :viewed_at,
                :cancelled_at, :validated_at, :absent_at, :finalized_at,
                :restaurant_id, :user_id, :service_id,
                :user_balance, :restaurant_balance, :discount,
                :user_contribution, :booking_name

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      Reservation.get_unarchived
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
    column :discount
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
  filter :discount
  filter :user_contribution
  filter :booking_name
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Service Details" do
      f.input :confirmation
      f.input :nb_people
      f.input :time
      f.input :status
      f.input :viewed_at
      f.input :cancelled_at
      f.input :validated_at
      f.input :absent_at
      f.input :finalized_at
      f.input :restaurant_id
      f.input :user_id
      f.input :service_id
      f.input :bill_amount
      f.input :restaurant_balance
      f.input :discount
      f.input :user_contribution
      f.input :booking_name
    end
    f.actions
 end
end

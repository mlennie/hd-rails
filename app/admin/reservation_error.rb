ActiveAdmin.register ReservationError do
  permit_params :restaurant_id, :reservation_id, :user_id, :kind, :description
  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      ReservationError.get_unarchived
    end

    def destroy
      r = ReservationError.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_restaurant_reservation_errors_path r.restaurant
    end
  end

  index do
    selectable_column
    id_column
    column :restaurant_id
    column :reservation_id
    column :user_id
    column(:kind) do |r|
      case r.kind
      when 0
        'amount wrong'
      when 1
        'not absent'
      when 2
        'bad service'
      when 3
        'other'
      end
    end
    column :description
    column :created_at
    column :updated_at
    actions
 end

  filter :restaurant_id
  filter :reservation_id
  filter :user_id
  filter :kind, :as => :select, :collection => ['amount_wrong',
              'not_absent', 'bad_service', 'other']
  filter :description
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Reservation Error Details" do
      f.input :restaurant_id
      f.input :reservation_id
      f.input :user_id
      f.input :kind, :as => :select, :collection => ['amount_wrong',
              'not_absent', 'bad_service', 'other']
      f.input :description
    end
    f.actions
 end
end

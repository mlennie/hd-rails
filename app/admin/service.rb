ActiveAdmin.register Service do
  permit_params :availabilities, :start_time, :last_booking_time,
                :restaurant_id, :nb_10, :nb_15, :nb_20, :nb_25

  belongs_to :restaurant

  controller do
    def scoped_collection
      Service.get_unarchived
    end

    def destroy
      r = Service.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_restaurant_services_path r.restaurant
    end
  end

  index do
    selectable_column
    id_column
    column :availabilities
    column :start_time
    column :last_booking_time
    column :restaurant_id
    column :nb_10
    column :nb_15
    column :nb_20
    column :nb_25
    actions
 end

  filter :availabilities
  filter :start_time
  filter :last_booking_time
  filter :restaurant_id
  filter :nb_10
  filter :nb_15
  filter :nb_20
  filter :nb_25

  form do |f|
    f.inputs "Service Details" do
      f.input :availabilities
      f.input :start_time
      f.input :last_booking_time
      f.input :restaurant_id, as: :select, collection: Restaurant.get_unarchived
      f.input :nb_10
      f.input :nb_15
      f.input :nb_20
      f.input :nb_25
    end
    f.actions
 end
end

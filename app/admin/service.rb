ActiveAdmin.register Service do
  permit_params :availabilities, :start_time, :last_booking_time,
                :restaurant_id, :nb_10, :nb_15, :nb_20, :nb_25,
                :start_time_date, :start_time_time_hour, :start_time_time_minute,
                :last_booking_time_date, :last_booking_time_time_hour, 
                :last_booking_time_time_minute

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      Service.get_unarchived.where(restaurant_id: params[:restaurant_id])
    end

    def create
      params[:service][:restaurant_id] = params[:restaurant_id]
      super
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
      if params[:service_template_id]
        f.input :service_template_id, value: params[:service_template_id]
      end 
      f.input :availabilities
      f.input :start_time, :as => :just_datetime_picker
      f.input :last_booking_time, :as => :just_datetime_picker
      f.input :nb_10
      f.input :nb_15
      f.input :nb_20
      f.input :nb_25
    end
    f.actions
 end
end

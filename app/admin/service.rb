ActiveAdmin.register Service do
  permit_params :availabilities, :start_time, :last_booking_time,
                :restaurant_id, :nb_10, :nb_15, :nb_20, :nb_25,
                :start_time_date, :start_time_time_hour, :start_time_time_minute,
                :last_booking_time_date, :last_booking_time_time_hour, 
                :last_booking_time_time_minute, :service_template_id, :service_template,
                :template_day

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      Service.get_unarchived.where(restaurant_id: params[:restaurant_id])
    end

    def create
      if params[:service][:service_template_id]

        service = Service.new

        ##had to put in the ugly params individually because Service.new(params[:service])
        #would not work
        service.availabilities = params[:service][:availabilities].to_i
        service.service_template_id = params[:service][:service_template_id].to_i
        service.template_day = params[:service][:template_day]
        service.start_time = params[:service][:start_time]
        service.last_booking_time = params[:service][:last_booking_time]
        service.nb_10 = params[:service][:nb_10].to_i
        service.nb_15 = params[:service][:nb_15].to_i
        service.nb_20 = params[:service][:nb_20].to_i
        service.nb_25 = params[:service][:nb_25].to_i

        if service.save!
          flash[:notice] = "Nice! you successfully added a new service to this template. Way to go!! High Five ;)"
          redirect_to edit_admin_service_template_path params[:service][:service_template_id]
        else
          flash[:danger] = "Ooh looks like something bad happened and our whole univers as we know it just collapsed. opps :( Please try again soon."
          redirect_to new_admin_service_path(service, params[:service][:service_template_id])
        end
      else
        params[:service][:restaurant_id] = params[:restaurant_id]
        super
      end
    end

    def destroy
      r = Service.find(params[:id])
      r.archive
      flash[:notice] = "You have successfully archived this resource"
      if params[:service_template_id]
        flash[:notice] = "You Successfully removed this service"
        redirect_to edit_admin_service_template_path params[:service_template_id]
      else
        redirect_to admin_restaurant_services_path r.restaurant
      end
    end
  end

  index do
    selectable_column
    id_column
    column :availabilities
    column :start_time
    column :last_booking_time
    column :restaurant
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
    if st_id = params[:service_template_id]
      day = params[:day]
      message = "Service details for Service Template: #{st_id}"
    else
      message = "Service details"
    end
    f.inputs message do
      if st_id
        f.input :service_template_id, label: false, input_html: {value: st_id } #, type: :hidden}
        f.input :template_day, label: false, input_html: {value: day} #, type: :hidden}
      end 
      f.input :availabilities
      if st_id
        f.input :start_time, :as => :time_picker, :max => "24:00", show24Hours: true
        f.input :last_booking_time, :as => :time_picker, :max => "24:00"
      else
        f.input :start_time, :as => :just_datetime_picker
        f.input :last_booking_time, :as => :just_datetime_picker
      end
      f.input :nb_10
      f.input :nb_15
      f.input :nb_20
      f.input :nb_25
    end
    f.actions
 end
end

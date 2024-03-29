ActiveAdmin.register Service do
  config.filters = false
  menu false
  permit_params :availabilities, :start_time, :last_booking_time,
                :restaurant_id, :nb_10, :nb_15, :nb_20, :nb_25,
                :start_time_date, :start_time_time_hour, :start_time_time_minute,
                :last_booking_time_date, :last_booking_time_time_hour, 
                :last_booking_time_time_minute, :service_template_id, :service_template,
                :template_day

  belongs_to :restaurant, optional: true

  batch_action :use_templates_for_services do 
    params[:date] = Restaurant.get_date_from_string params[:date]
    if !params[:whole_year] && !params[:week_one] && !params[:week_two] &&
           !params[:week_three] && !params[:week_four] && !params[:week_five] &&
           !params[:week_six] && !params[:whole_month]
      flash[:danger] = "Please select and option"
    elsif params[:whole_year]
      if Restaurant.use_template_to_create_services_for_12_months params
        flash[:notice] = "You successfully used a template to update the calendar"
      else
        flash[:danger] = "oops there was a problem, calendar could not be updated"
      end
    else
      if Restaurant.use_template_to_create_services params
        flash[:notice] = "You successfully used a template to update the calendar"
      else
        flash[:danger] = "oops there was a problem, calendar could not be updated"
      end
    end
    redirect_to admin_restaurant_services_path params[:restaurant_id], date: params[:date]
  end

  controller do
    def scoped_collection
      Service.limit(2)
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

        if service.last_booking_time.present? && 
           service.start_time.present? &&
           service.last_booking_time > (service.start_time + 30.minutes)
          if service.save!
            flash[:notice] = "Nice! you successfully added a new service to this template. Way to go!! High Five ;)"
            redirect_to edit_admin_service_template_path params[:service][:service_template_id]
          else
            flash[:danger] = "Ooh looks like something bad happened and our whole univers as we know it just collapsed. opps :( Please try again soon."
            redirect_to new_admin_service_path(service, day: params[:service][:template_day], service_template_id: params[:service][:service_template_id])
          end
        else
          flash[:danger] = "Oops last booking time must be at least 30 minutes after start time!"
          redirect_to new_admin_service_path(service, day: params[:service][:template_day], service_template_id: params[:service][:service_template_id])
        end
      else
        params[:service][:restaurant_id] = params[:restaurant_id]
        super
      end
    end

    def destroy

      #delete all restaurant's services if sent with "delete_all_services" param
      if params[:delete_all_services]
        restaurant = Restaurant.find(params[:restaurant_id]);
        services = restaurant.services.get_unarchived.today_or_future

        #filter all services
        services.all.each do |service|
          #archive unless service has reservations 
          service.delete unless service.reservations.any?
        end

        #send back to services page with proper flash message
        flash[:notice] = "You have successfully deleted all services (that didn't have reservations) for this restaruant"
        redirect_to admin_restaurant_services_path params[:restaurant_id]
      else
        r = Service.find(params[:id])
        unless r.reservations.any?
          r.delete
          if params[:service_template_id]
            flash[:notice] = "You Successfully removed this service"
            redirect_to edit_admin_service_template_path params[:service_template_id]
          else
            redirect_to admin_restaurant_services_path r.restaurant
          end
        else
          flash[:danger] = "This Service already has reservations and can therefore not be deleted."
          redirect_to admin_restaurant_services_path r.restaurant
        end
      end
    end
  end

  sidebar "Services and Reservations", only: [:show] do
    ul do
      li link_to "Reservations",    admin_reservations_path(service_id: service.id)
      li link_to "New Reservation", new_admin_reservation_path(service_id: service.id)
    end
  end

  index do
    render partial: "service_calendar", locals: { restaurant: Restaurant.find(params[:restaurant_id]) }
  end

  form do |f|
    if st_id = params[:service_template_id]
      day = params[:day]
      message = "Service details for Service Template: #{st_id}"
    else
      message = "Service details"
    end
    f.inputs message do
      if st_id
        f.input :service_template_id, label: false, input_html: {value: st_id, type: :hidden}
        f.input :template_day, label: false, input_html: {value: day, type: :hidden}
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

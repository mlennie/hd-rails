ActiveAdmin.register ServiceTemplate do
  permit_params :name, :description, :restaurant_id, :restaurant, 
                :use_for_automation

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      if params[:restaurant_id]
        ServiceTemplate.get_unarchived
        .where(restaurant_id: params[:restaurant_id].to_i)
      else
        ServiceTemplate.get_unarchived
      end
    end

    def destroy
      r = ServiceTemplate.find(params[:id])
      #check to make sure its not a master that is used for automation. 
      #there must be at least one master used for automation
      unless r.restaurant_id.blank? && r.use_for_automation
        r.services.all.each do |service|
          service.archive
        end
        r.archive
        flash[:success] = "You have successfully archived this resource"
        redirect_to admin_service_templates_path
      else
        flash[:danger] = "Skynet protocol has overriden this request. " + 
                         "There must always be one master template that " +
                         "is used for service creation automation. " +
                         "Please edit another master template to be used for " +
                         "automation, and then you can delete this template. " +
                         "Hail SKYNET"
        redirect_to admin_service_template_path r
      end
    end

    def create
      unless params[:service_template][:restaurant_id]
        params[:service_template][:restaurant_id] = params[:restaurant_id]
      end
      super
    end

    def update
      name = params[:service_template][:name]
      description = params[:service_template][:description]
      restaurant_id = params[:service_template][:restaurant_id]
      service_template_id = params[:id]
      other_template_id = params[:service_template_id]
      use_for_automation = params[:service_template][:use_for_automation]

      service_template = ServiceTemplate.find(service_template_id)

      #add check: if template is master automation template, dont allow it to 
      #connect to a restaurant (because then there would be no more master 
      #automation templates left)
      if service_template.restaurant_id.nil? &&
         service_template.use_for_automation  &&
         restaurant_id.present?
         flash[:danger] = "Skynet protocol has overriden this request. " + 
                         "There must always be one master template that " +
                         "is used for service creation automation. " +
                         "Please edit another master template to be used for " +
                         "automation, and then you can make this not a master template. " +
                         "Hail SKYNET"
         redirect_to edit_admin_service_template_path service_template.id
         return true
      end

      ServiceTemplate.add_services_from_template(service_template, other_template_id)

      service_template.name = name
      service_template.description = description
      service_template.restaurant_id = restaurant_id
      service_template.use_for_automation = use_for_automation

      if service_template.save
        flash[:notice] = "You have successfully updated this template"
        redirect_to admin_service_template_path service_template_id
      else
        flash[:notice] = "Oops template could not be updated :/"
        redirect_to edit_admin_service_template_path service_template.id
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :use_for_automation
    column :restaurant
    column :created_at
    column :updated_at
    actions
  end

  show do 
    attributes_table do
      row :name
      row :description
      row :restaurant
      row :use_for_automation
    end
    days = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

    days.each do |day|

      panel day do
        render partial: "service_template_day", locals: {day: day, id: params[:id], show: true}
      end
    end
  end

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Tempalte Details" do
      f.input :name
      f.input :description
      #don't show restaurant select if came through a restaurant to get here.
      #don't show if this is an edit page and there is only one service template
      #or if this is a new page and there are not service templates yet (there should
      #always be at least one master template)
      unless params[:restaurant_id] || 
        (params[:id] && 
        ServiceTemplate.get_unarchived.where(restaurant_id: nil).count == 1 &&
        ServiceTemplate.get_unarchived.find(params[:id]).restaurant_id.blank?) ||
        ServiceTemplate.get_unarchived.count  == 0
        f.input :restaurant, label: "Restaurant (leave blank if this is a Master Template)"
      end
      unless params[:id] && ServiceTemplate.get_unarchived.find(params[:id]).restaurant_id.nil?
        f.input :use_for_automation, 
                label: "Use for automating service creation? If this is a master template, " +
                       "this will REMOVE the other master template from being used to automate " +
                       "service creation."
      end
    end
    f.actions

    if params[:id]
      panel "Services" do 
        render partial: "service_template_select", locals: { id: params[:id] }
        days = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

        days.each do |day|

          panel day do
            render partial: "service_template_day", locals: {day: day, id: params[:id], show: false}
          end
        end
      end
    end
  end

end
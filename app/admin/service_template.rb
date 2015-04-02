ActiveAdmin.register ServiceTemplate do
  permit_params :name, :description, :restaurant_id, :restaurant

  belongs_to :restaurant, optional: true

  controller do
    def scoped_collection
      ServiceTemplate.get_unarchived
    end

    def destroy
      r = ServiceTemplate.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_service_templates_path
    end

    def create
      unless params[:service_template][:restaurant_id]
        params[:service_template][:restaurant_id] = params[:restaurant_id]
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
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
    end
    days = %w(Monday Tuesday Wedesday Thursday Friday Saturday Sunday)

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
      unless params[:restaurant_id]
        f.input :restaurant
      end
    end
    f.actions

    if params[:id]
      panel "Services" do 
        render partial: "service_template_select", locals: { id: params[:id] }
        days = %w(Monday Tuesday Wedesday Thursday Friday Saturday Sunday)

        days.each do |day|

          panel day do
            render partial: "service_template_day", locals: {day: day, id: params[:id], show: false}
          end
        end
      end
    end
  end

end
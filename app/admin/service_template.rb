ActiveAdmin.register ServiceTemplate do
  permit_params 

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
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Menu Details" do
      f.input :name
      f.input :description

      if params[:id]

        days = %w(Monday Tuesday Wedesday Thursday Friday Saturday Sunday)

        days.each do |day|

          panel day do
            render partial: "service_template_day", locals: {day: day, id: params[:id]}
          end
        end
      end
    end
    f.actions
  end

end
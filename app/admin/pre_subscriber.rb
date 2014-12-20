ActiveAdmin.register PreSubscriber do
  permit_params :first_name, :last_name, :email

  controller do
    def scoped_collection
      PreSubscriber.get_unarchived
    end

    def destroy
      r = PreSubscriber.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_pre_subscribers_path 
    end
  end

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :created_at
    actions
 end

  filter :first_name
  filter :last_name
  filter :email
  filter :created_at

  form do |f|
    f.inputs "Service Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
 end
end
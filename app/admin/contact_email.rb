ActiveAdmin.register ContactEmail do
  permit_params :name, :email, :user_id, :content

  controller do
    def scoped_collection
      ContactEmail.get_unarchived
    end

    def destroy
      r = ContactEmail.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_pre_subscribers_path 
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :user_id
    column :content
    column :created_at
    actions
 end

  filter :name
  filter :email
  filter :user_id
  filter :content
  filter :created_at

  form do |f|
    f.inputs "Contact Email Details" do
      f.input :name
      f.input :email
      f.input :user_id
      f.input :content
    end
    f.actions
 end
end
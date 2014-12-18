ActiveAdmin.register Promotion do
  permit_params :name, :code, :description, :amount, :percent, :new_user_only,
  							:expiry_date, :usage_limit, :times_used

  controller do
    def scoped_collection
      Promotion.get_unarchived
    end

    def destroy
      r = Promotion.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_promotions_path
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :description
    column :amount 
    column :percent
    column :new_user_only
    column :expiry_date
    column :usage_limit
    column :times_used
    column :created_at
    actions
 end

  filter :name
  filter :code
  filter :description
  filter :amount 
  filter :percent
  filter :new_user_only
  filter :expiry_date
  filter :usage_limit
  filter :times_used
  filter :created_at

  form do |f|
    f.inputs "Promotion Details" do
      f.input :name
	    f.input :code
	    f.input :description
	    f.input :amount 
	    f.input :percent
	    f.input :new_user_only
	    f.input :expiry_date
	    f.input :usage_limit
	    f.input :times_used
    end
    f.actions
 end
end

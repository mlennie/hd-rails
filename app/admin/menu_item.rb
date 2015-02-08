ActiveAdmin.register MenuItem do
  permit_params :menu_id, :course, :name, :description, :price

  belongs_to :menu

  controller do
    def scoped_collection
      MenuItem.where(menu_id: params[:menu_id]).get_unarchived
    end

    def destroy
      r = MenuItem.find(params[:id])
      r.archive
      flash[:success] = "You have successfully archived this resource"
      redirect_to admin_menu_menu_items_path r.menu
    end
  end

  index do
    selectable_column
    id_column
    column :course
    column :name
    column :description
    column :price
    column :menu_id
    actions
  end

  filter :course
  filter :name
  filter :description
  filter :price
  filter :menu_id

  form do |f|
    f.inputs "Menu Details" do
      f.input :course, as: :select, collection: MenuItem.courses.keys
      f.input :name
      f.input :description
      f.input :price
    end
    f.actions
  end

end

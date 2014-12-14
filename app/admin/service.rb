ActiveAdmin.register Service do
  permit_params :list, :of, :attributes, :on, :model

  belongs_to :restaurant
end

ActiveAdmin.register Reservation do
  permit_params :list, :of, :attributes, :on, :model
  belongs_to :restaurant, optional: true
end

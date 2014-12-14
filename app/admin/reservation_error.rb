ActiveAdmin.register ReservationError do
  permit_params :list, :of, :attributes, :on, :model
  belongs_to :restaurant, optional: true
end

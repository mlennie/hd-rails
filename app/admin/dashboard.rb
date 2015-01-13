ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  
  content do
    panel 'Reservations' do

      table_for Reservation.get_unarchived.order('id DESC').each do |reservation|
        column(:id) do |reservation| 
          link_to reservation.id, admin_reservation_path(reservation) 
        end
        column(:status)
        column(:booking_name)
        column(:nb_people) 
        column(:time)
        column(:restaurant) do |reservation| 
          link_to reservation.restaurant, admin_restaurant_path(reservation.restaurant.id) rescue nil 
        end
        column(:user) do |reservation| 
          link_to reservation.user, admin_user_path(reservation.user.id) rescue nil 
        end
        column(:discount) do |reservation|
          (reservation.discount * 100).round.to_s + '%' rescue nil
        end
        column(:user_contribution) do |reservation|
          reservation.user_contribution.round(2).to_s + '€' rescue nil
        end
      end
    end
  end
end

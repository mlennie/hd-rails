class AddQuestionsToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :wants_sms_per_reservation, :boolean
    add_column :restaurants, :wants_phonecall_per_reservation, :boolean
    add_column :restaurants, :has_computer_in_restaurant, :boolean
    add_column :restaurants, :cuts_midi_sevice_in_2, :boolean
    add_column :restaurants, :cuts_soir_service_in_2, :boolean
    add_column :restaurants, :service_midi_start, :time
    add_column :restaurants, :service_midi_end, :time
    add_column :restaurants, :service_soir_start, :time
    add_column :restaurants, :service_soir_end, :time
    add_column :restaurants, :day_with_less_people, :string
    add_column :restaurants, :day_with_most_people, :string
    add_column :restaurants, :want_10_or_more_people, :boolean
    add_column :restaurants, :client_more_business, :boolean
    add_column :restaurants, :client_more_tourists, :boolean
  end
end

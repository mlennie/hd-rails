class ServiceTemplate < ActiveRecord::Base

	include Archiving

	has_many :services
	belongs_to :restaurant

	#filter templates based on master templates (no restaurant id attached)
	#or templates belonging to current restaurant (restaurant id that equals 
		#current template restaurant id)
	def self.get_templates id
		template = find(id)
		template_ids = []

		find_each do |st|
			template_ids << st.id unless st.restaurant_id
			if template.restaurant_id
				if st.restaurant_id == template.restaurant_id
			  	template_ids << st.id 
			  end
			end
		end

		return where(id: template_ids)
	end

	def self.has_services? id
		s_ids = []
		find(id.to_i).services.each do |s|  
			s_ids << s.id unless s.archived? 
		end
		s_ids.any?
	end

	#use another template's services to create new services for current template
	def self.add_services_from_template(service_template, other_template_id)
		return if other_template_id.blank?
		other_template = ServiceTemplate.find(other_template_id)

		if service_template && other_template
			other_services = other_template.services.get_unarchived
			other_services.each do |other_service|
				new_service = service_template.services.new
				new_service.availabilities = other_service.availabilities
				new_service.start_time = other_service.start_time
				new_service.last_booking_time = other_service.last_booking_time
				new_service.nb_10 = other_service.nb_10
				new_service.nb_15 = other_service.nb_15
				new_service.nb_20 = other_service.nb_20
				new_service.nb_25 = other_service.nb_25
				new_service.template_day = other_service.template_day
				new_service.save!
			end
		end
	end
end

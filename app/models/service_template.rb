class ServiceTemplate < ActiveRecord::Base

	include Archiving

	has_many :services
	belongs_to :restaurant

	#if no other master templates are being used for automation (first template)
	#change use_for_automation to true for this template
	before_save :check_for_automation

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

	def check_for_automation
		#remove other automations if this template has been chosen to replace
		#others for automation
		self.remove_other_automations_if_needed

		#if no other master templates are being used for automation
		#set this template true for automation
		self.set_automation_if_first_master
	end

	def set_automation_if_first_master
		#return if automation is already set to true
		return if self.use_for_automation

		#return if not a master template
		return if self.restaurant_id.present?

		#check to see if there are any other master templates 
		#being used for automation and return if so
		master_templates = ServiceTemplate.where(restaurant_id: nil)
		master_automation_templates = master_templates.where(use_for_automation: true)
		return if master_automation_templates.any?

		#if passes, set use_for_automation to true
		self.use_for_automation = true
	end

	def remove_other_automations_if_needed
		#return if template doesn't have automation set to true
		return if !self.use_for_automation

		#if restaurant template, remove automation from all other
		#templates for same restaurant
		if self.restaurant_id.present?
			templates = ServiceTemplate.where(restaurant_id: self.restaurant_id)
		else
			#if master template, remove automation from all other master templates
			templates = ServiceTemplate.where(restaurant_id: nil)
		end
		ServiceTemplate.change_automation_to_false_unless_current(self, templates)
	end

	#change all templates automation to false unless its the current_template
	def self.change_automation_to_false_unless_current current_template, templates
		templates.all.each do |template|
			if template.use_for_automation && template != current_template
				template.use_for_automation = false
				template.save!
			end
		end
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

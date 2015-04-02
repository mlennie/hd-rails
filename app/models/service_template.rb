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
end

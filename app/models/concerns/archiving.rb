module Archiving
  extend ActiveSupport::Concern

  def archive
    self.update(archived: true)
  end

  module ClassMethods
    def get_unarchived
      where(archived: false)
    end
  end

end
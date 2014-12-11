class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles

  def self.superadmin
    find_by(name: "superadmin")
  end
end

class User < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable

  has_many :user_roles
  has_many :roles, through: :user_roles
end

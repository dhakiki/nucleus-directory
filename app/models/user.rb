class User < ActiveRecord::Base
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  has_many :skills
  accepts_nested_attributes_for :skills, allow_destroy: true, reject_if: lambda { |a| a[:name].blank? }
end

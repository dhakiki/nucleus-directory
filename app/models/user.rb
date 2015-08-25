class User < ActiveRecord::Base
  LEVELS = ['Junior', 'Mid', 'Senior']
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_uniqueness_of :email
  has_many :skills
  accepts_nested_attributes_for :skills, allow_destroy: true, reject_if: lambda { |a| a[:name].blank? }
  has_one :google_account
  accepts_nested_attributes_for :google_account
  has_many :subordinates, class_name: 'User', foreign_key: :supervisor_id
  belongs_to :supervisor, class_name: 'User'
end

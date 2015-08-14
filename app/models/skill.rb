class Skill < ActiveRecord::Base
  SKILL_LEVELS = {"Beginner": 1, "Intermediate": 3, "Expert": 5, "Leader": 7}
  validates_presence_of :name
  validates_presence_of :level
  belongs_to :user
end

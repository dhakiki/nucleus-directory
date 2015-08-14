FactoryGirl.define do

  factory :user do
    first_name 'Will'
    last_name 'Smith'
    email 'will.smith@originate.com'
  end

  factory :skill do
    name 'Acting'
    level 1
    user_id 1
  end
end

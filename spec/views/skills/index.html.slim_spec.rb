require 'rails_helper'

RSpec.describe "skills/index", type: :view do
  before(:each) do
    assign(:skills, [
      Skill.create!(
        :name => "Name",
        :level => 1,
        :user_id => 2
      ),
      Skill.create!(
        :name => "Name",
        :level => 1,
        :user_id => 2
      )
    ])
  end

  it "renders a list of skills" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end

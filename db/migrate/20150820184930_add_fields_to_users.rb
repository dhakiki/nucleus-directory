class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :string
    add_column :users, :title, :string
    add_column :users, :position, :string, default: 'Mid'
    add_column :users, :twitter_profile, :string
    add_column :users, :github_profile, :string
    add_column :users, :additional_link, :string
    add_column :users, :location, :string
    add_column :users, :industry_experiences, :string
    add_column :users, :industry_interests, :string
    add_column :users, :technology_interests, :string
    add_column :users, :notes, :string
    add_column :users, :start_date, :datetime
    add_column :users, :disabled, :boolean
    add_column :users, :supervisor_id, :integer
  end
end

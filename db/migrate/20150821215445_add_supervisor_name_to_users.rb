class AddSupervisorNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :supervisor_name, :string
  end
end

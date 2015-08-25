class CreateGoogleAccount < ActiveRecord::Migration
  def change
    create_table :google_accounts do |t|
      t.string :google_id
      t.string :token
      t.string :name
      t.string :email
      t.string :picture 
      t.string :user_id
    end
  end
end

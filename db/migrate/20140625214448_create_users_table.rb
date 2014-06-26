class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table(:users) do |t|
  		t.string(:fname)
  		t.string(:lname)
  		t.string(:email)
  		t.integer(:zipcode)
  		t.string(:password)
  	end
  end
end

class AddName < ActiveRecord::Migration
  def change
  	add_column("users","name",:string,limit:40)
  end
end

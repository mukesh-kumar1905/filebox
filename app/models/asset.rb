class Asset < ActiveRecord::Base
  belongs_to :user  
  #set up "uploaded_file" field as attached_file (using Paperclip)  
	has_attached_file :uploaded_file,
		url: "assets/get/:id",path: ":rails_root/assets/:id/:basename.:extension" 
	validates_attachment_size :uploaded_file, :less_than => 10.megabytes    
	validates_attachment_presence :uploaded_file 
	belongs_to :folder   
	def file_name  
    	uploaded_file_file_name  
	end   
	def file_size  
    	uploaded_file_file_size  
	end  
	
end

class AssetsController < ApplicationController
  
   #authenticate for users before any methods is called 
  before_filter :authenticate_user!

  def index
     @assets = current_user.assets       
  end


  def new
    @asset = current_user.assets.build      
    if params[:folder_id] #if we want to upload a file inside another folder  
     @current_folder = current_user.folders.find(params[:folder_id])  
     @asset.folder_id = @current_folder.id  
    end 
  end

  def create
  @asset = current_user.assets.build(asset_params)  
  if @asset.save  
   flash[:notice] = "Successfully uploaded the file."  
  
   if @asset.folder #checking if we have a parent folder for this file  
     redirect_to browse_path(@asset.folder)  #then we redirect to the parent folder  
   else
     redirect_to root_url
   end        
  else  
   render :action => 'new'  
  end
  end

  def edit
    @asset = current_user.assets.find(params[:id])  
  end
  def show
    @asset = current_user.assets.find(params[:id])
  end
  def update
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
  @asset = current_user.assets.find(params[:id])  
  @parent_folder = @asset.folder #grabbing the parent folder before deleting the record  
  @asset.destroy  
  flash[:notice] = "Successfully deleted the file."  
  
  #redirect to a relevant path depending on the parent folder  
  if @parent_folder  
   redirect_to browse_path(@parent_folder)  
  else  
   redirect_to root_url  
  end  
  end

  def get  
    asset = current_user.assets.find_by_id(params[:id])  
    if asset  
         send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type  
    else
      flash[:error] = "Don't be cheeky! Mind your own assets!"  
      redirect_to assets_path  
    end 
  end

  private

  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def asset_params
    params.require(:asset).permit(:uploaded_file,:folder_id)
  end

end

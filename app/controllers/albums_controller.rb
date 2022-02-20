class AlbumsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show, :search, :index]
  before_action :find_album, only: [:edit, :update, :show, :destroy]
  before_action :activeconf, only: [:index, :new, :draft]
  $publish = true

  def index    
    if user_signed_in?
      @q = current_user.albums.ransack(params[:q]) 
    else
      @q = Album.ransack(params[:q])             
    end
    @albums = @q.result(distinct: true).includes(:tags)
    
    $publish = true
    $index="active"
  end

  def draft
    @albums=current_user.albums    
    $publish = false
    $draft="active"  
  end

  def new
    @album=current_user.albums.build
    $albumbtn="Create Album"
    $addnew="active"
  end

  def create
    @album=current_user.albums.build(params_album)    
    if @album.save
      redirect_to @album
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    $albumbtn="Update Album"
  end

  def update
    if @album.update(params_album)
      redirect_to @album
    else
      render :edit,status: :unprocessable_entity
    end
  end

  def show    
  end

  def destroy
    if @album.destroy
      redirect_to root_path, status: :see_other
    end    
  end

  def delete_image
    image=ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_back fallback_location: image, status: :see_other
  end

  private 

  def params_album
    params.required(:album).permit(:title, :description, :album_pic,:publish,:album_tags,images: [])
  end

  def find_album
    @album=Album.find(params[:id])
    if current_user && @album.user_id != current_user.id
      redirect_to root_path, alert: "Album does not exist..."
    elsif current_user == nil && @album.publish == false
      redirect_to root_path, alert: "Album does not exist..."
    end
  end

  def activeconf
    $addnew=""
    $draft=""
    $index=""
  end

end
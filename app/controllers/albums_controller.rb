class AlbumsController < ApplicationController
  before_action :authenticate_user!, :except => [:home, :show]
  before_action :find_album, only: [:edit, :update, :show, :destroy]
  before_action :find_albums
  before_action :activeconf, only: [:home, :new, :draft]
  $publish = true
  $tags=""

  def search
    $tags=params[:query]
    if user_signed_in?
      @albums=Tag.find_by!(name: params[:query]).albums.where(user_id: current_user)
    else
      @albums=Tag.find_by!(name: params[:query]).albums
    end
    if $publish == true
      render :home
    else
      render :draft
    end
  end

  def draft
    $tags=""
    $publish = false
    $draft="active"
  end

  def home
    $tags=""
    $publish = true
    $home="active"
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
    # Tagging.destroy_by(album_id: params[:id])
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
      redirect_to root_path, notice: "Album does not exist..."
    elsif current_user == nil && @album.publish == false
      redirect_to root_path, notice: "Album does not exist..."
    end
  end

  def find_albums
    if user_signed_in?
      @albums=Album.where(user_id: current_user)
    else
      @albums=Album.all
    end
  end

  def activeconf
    $addnew=""
    $draft=""
    $home=""
  end

end
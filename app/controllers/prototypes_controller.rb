class PrototypesController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
    redirect_to root_path
    else
    render :new
    end
    end

    def show
      @prototype = Prototype.find(params[:id])
      @comment = Comment.new
      @comments = @prototype.comments.includes(:user)
    end

    def update
      @prototype = Prototype.find(params[:id])
    
      if @prototype.update(prototype_params)
        redirect_to @prototype, notice: 'プロトタイプを更新しました'
      else
        render :edit
      end
    end

    def edit
      if user_signed_in?
        @prototype = Prototype.find(params[:id])
      else
        redirect_to root_path
      end
    end

    def destroy
      @prototype = Prototype.find(params[:id])
      @prototype.destroy
      redirect_to prototypes_path, notice: "Prototype was successfully deleted."
    end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :image, :catch_copy, :concept).merge(user_id: current_user.id)
  end
end

  def correct_user
    @prototype = current_user.prototypes.find_by(id: params[:id])
    redirect_to root_url if @prototype.nil?
  end
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, except: :show
  before_action :load_user, only: [:show, :update, :destroy]

  def index
    respond_with(@users = User.all)
  end

  def show
    return unless current_user.admin?
    redirect_to :back, alert: 'Access denied.' unless @user == current_user
  end

  def update
    @user.update_attributes(secure_params)
    respond_with @user
  end

  def destroy
    @user.destroy if @user.role == 'admin'
    respond_with @user
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def admin_only
    redirect_to :back, alert: 'Access denied.' unless current_user.admin?
  end

  def secure_params
    params.require(:user).permit(:role)
  end
end

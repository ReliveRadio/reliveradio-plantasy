class AdminsController < ApplicationController
  before_action :set_admin, only: [:destroy, :approve]
  before_filter :authenticate_admin!

  def index
    @admins = Admin.all
  end

  def approve
    @admin.approved = true
    respond_to do |format|
      if @admin.save
        format.html { redirect_to '/admins', notice: 'User approved.' }
      end
    end
  end

  def destroy
    if @admin.destroy
      redirect_to '/admins', notice: "User deleted."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end
  end

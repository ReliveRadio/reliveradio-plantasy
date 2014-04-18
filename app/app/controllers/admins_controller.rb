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
        AdminMailer.delay(:queue => 'mailer').admin_approved(@admin.id)
        format.html { redirect_to '/admins', notice: 'User approved.' }
      end
    end
  end

  def destroy
    email = @admin.email
    if @admin.destroy
      AdminMailer.delay(:queue => 'mailer').admin_destroy(email)
      redirect_to '/admins', notice: "User deleted."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end
end

class AdminMailer < ActionMailer::Base
  default from: Figaro.env.mailer_from_address

  def new_admin_waiting_for_approval(admin_id)
    @admin = Admin.find(admin_id)
    mail(to: @admin.email, subject: 'Waiting for approval')
  end

  def admin_approved(admin_id)
  	@admin = Admin.find(admin_id)
  	mail(to: @admin.email, subject: 'You have been approved')
  end

  def admin_destroy(email)
  	mail(to: email, subject: 'Your account has been deleted')
  end
end

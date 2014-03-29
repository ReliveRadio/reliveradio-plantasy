require 'action_view'

class SidekiqStatusController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  def status
  	@job_id = params[:id]
  	@status = Sidekiq::Status::status(@job_id)
  	@done = number_to_human_size(Sidekiq::Status::num @job_id)
	@total = number_to_human_size(Sidekiq::Status::total @job_id)
	@percentage = (Sidekiq::Status::pct_complete @job_id).round
	# Sidekiq::Status::queued?   job_id
	# Sidekiq::Status::working?  job_id
	# Sidekiq::Status::complete? job_id
	# Sidekiq::Status::failed?   job_id
	respond_to do |format|
		format.html {}
		format.js {}
	end
  end
end

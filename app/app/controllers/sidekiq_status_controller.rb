class SidekiqStatusController < ApplicationController
  def status
  	@job_id = params[:id]
  	@status = Sidekiq::Status::status(@job_id)
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

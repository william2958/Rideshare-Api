class ApplicationController < ActionController::API

	# We use authenticate! which is the authenticator that handles tokens
	# and not the one with emails and passwords because every action that 
	# extends this controller is a request for something inside a user
	# like account_controller, never user_controller
	# This means you MUST have a token to access any action that extends
	# this controller

	before_action :authenticate!

	# Allow controllers to access the :current_user object
	attr_reader :current_user

	private

	# Call the authorize_api_request class to check the token given
	def authenticate!
		@current_user = AuthorizeApiRequest.call(request.headers).result
		# If unauthorized return an error to the front end
		render json: {error: 'Not Authorized'}, status: 401 unless @current_user
	end

end

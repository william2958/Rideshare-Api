class AuthorizeApiRequest

	# This class handles an http request with an token
	# This is called when a user request something that's not sign_in
	# Because it is called from before_action :authenticate! from the 
	# application controller

	prepend SimpleCommand

	# Initialize with headers
	def initialize(headers = {})
		@headers = headers
	end

	# Called from ApplicationController authenticate!
	def call
		user
	end

	private

	attr_reader :headers

	def user
		# Find the user from the decoded authorization token, 
		# and retreive the user_id from the decoded array
		@user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
		# reutrn @user if the user was found b/c short hand boolean statement
		@user || errors.add(:token, 'Invalid token') && nil
	end

	def decoded_auth_token
		# Decode the token given by the http request
		@decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
	end

	def http_auth_header
		# This fetches the authorization token from the http request
		if headers['Authorization'].present?
			return headers['Authorization'].split(' ').last
		else
			errors.add(:token, 'Missing token')
		end
		nil
	end
end
class AuthenticateUser
	prepend SimpleCommand

	# This is used to fetch the email and password from the 
	# call(email, password) call from authentication_controller
	def initialize(email, password)
		@email = email
		@password = password
	end

	def call
		# Encode a token with the user_id if user exists
		# returns the token in and object with key result
		JsonWebToken.encode(user_id: user.id) if user
	end

	private

	def user
		# Checks that user exists
		user = User.find_by(email: @email)
		# Checks the user password is correct
		if user && user.authenticate(@password)
			# return the user object
			return user 
		else
			# Authorization failed
			errors.add :user_authentication, 'invalid credentials'
			nil
		end
	end
end
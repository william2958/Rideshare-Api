class UserMailer < ApplicationMailer

	default from: 'crimsonlockconfirmation@gmail.com'

	# Send the email confirmation email
	# Connects to welcome_email.html.erb in the views
	def welcome_email(user)
		@user = user
		mail(to: @user.email, subject: 'Welcome to Friday.')
		nil
	end

	# Send the for got password email with the reset link
	# Connects to the forgot_password.html.erb
	def forgot_password(user)
		@user = user
		mail(to: @user.email, subject: 'Reset Password')
		nil
	end

	def cancelled_trip(user) 
		@user = user
		mail(to: @user.email, subject: 'Trip Cancelled')
		nil
	end

	def accepted_email(user)
		@user = user
		mail(to: @user.email, subject: 'Request Accepted')
		nil
	end

end

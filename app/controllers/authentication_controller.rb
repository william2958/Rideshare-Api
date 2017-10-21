class AuthenticationController < ApplicationController
	skip_before_action :authenticate!

	# This authenticates the user by password password
	# This is called by the router from '/sign_in'
	def authenticate 

		# Check that the user exists
		if User.find_by(email: params[:email])

			# Call AuthenticateUser with an email and password
			# This genereates a token if email and password match
			command = AuthenticateUser.call(params[:email], params[:password])

			# If AuthenticateUser was a success
			if command.success?
				# Check that the user has confirmed their email
				if User.find_by(email: params[:email]).email_confirmed
					@user = User.find_by(email: params[:email])
					# Return the authorization token back to the user
					# Which was returned by JWT
					render json: { 
						id: @user.id.to_s,
						first_name: @user.first_name,
						last_name: @user.last_name,
						auth_token: command.result,
						first_time: @user.first_time,
						driver_rating: @user.driver_rating,
						rider_rating: @user.rider_rating,
						trips_driving: @user.trips_driving,
						trips_requested: @user.trips_requested,
						facebook_link: @user.facebook_link,
						phone_number: @user.phone_number,
						past_trips_driven: @user.past_trips_driven,
						past_trips_requested: @user.past_trips_requested,
						first_time_driver: @user.first_time_driver,
						license_plate: @user.license_plate,
						car_model: @user.car_model
					}
				else
					# Tell the front end the email has not been confirmed
					render json: { 
						status: 'error',
						message: 'Email has not been confirmed!'
					}, status: :unauthorized
				end
			else
				# If the password was incorrect
				render json: {
					status: 'error',
					message: 'Incorrect Password!'
				}, status: :unauthorized
			end
		else
			# Couldn't find the account from the email
			render json: {
				status: 'error',
				message: 'Email could not be found!'
			}, status: 404
		end
	end
end
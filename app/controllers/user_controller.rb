class UserController < ApplicationController
	# Controls all user actions

	# Authenticate all the actions except for the following
	skip_before_action :authenticate!, only: [:create, :confirm_email, :forgot_password, :password_reset]

	# Get the user object
	def index
		if current_user
			render json: {
				id: current_user.id,
				email: current_user.email,
				first_name: current_user.first_name,
				last_name: current_user.last_name,
				first_time: current_user.first_time,
				driver_rating: current_user.driver_rating,
				rider_rating: current_user.rider_rating,
				trips_driving: current_user.trips_driving,
				trips_requested: current_user.trips_requested,
				trips_accepted: current_user.trips_accepted,
				facebook_link: current_user.facebook_link,
				phone_number: current_user.phone_number,
				past_trips_driven: current_user.past_trips_driven,
				past_trips_requested: current_user.past_trips_requested,
				first_time_driver: current_user.first_time_driver,
				license_plate: current_user.license_plate,
				car_model: current_user.car_model
			}
			current_user.first_time = false
			current_user.save!
		else	
			render json: {
				status: 'error',
				errors: ['Cannot find the account']
			}, status: 404
		end
	end

	# Create a new user object
	def create

		if User.find_by(email: user_params[:email])
			render json: {
		 		status: 'error',
		 		message: 'Email has already been taken!'
		 	}, status: 422 
		elsif User.find_by(phone_number: user_params[:phone_number])
			render json: {
				status: 'error',
				message: 'Phone number has already been taken!'
			}, status: 422
		else

			@user = User.create(user_params)

			if @user
				# If successfully created
				UserMailer.welcome_email(@user).deliver_now
				nil
				render json: {
					status: 'success',
					user: @user
				}, status: 200
				@user.confirm_token = SecureRandom.urlsafe_base64.to_s
		 		@user.save!
			else
				render json: {
					status: 'error',
					message: 'Missing a field!'
				}, status: 422
			end
		 	
		end
	    
	end

	# Function to update a user profile
	def update
		if current_user._id == user_params[:id]
			@user = User.find_by(:id => user_params[:id])
			@user.update({
				first_name: user_params[:first_name],
				last_name: user_params[:last_name],
				phone_number: user_params[:phone_number],
				facebook_link: user_params[:facebook_link],
				car_model: user_params[:car_model],
				license_plate: user_params[:license_plate]
			})
			@user.save!
			render json: {
				status: 'success',
				user: @user
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'You are not authorized to edit this field!'
			}, status: 422
		end
	end

	# Destroy a user object
	def destroy
		if current_user
			current_user.destroy
			render json: {
				status: 'success',
				message: "Account with uid #{@resource.uid} has been destroyed."
			}, status: 200
		else
			render json: {
				status: 'error',
				errors: ["Unable to locate account for destruction."]
			}, status: 404
		end
	end

	# Confirm the user by checking the confirm_token passed in the url
	def confirm_email
	    user = User.find_by(confirm_token: user_params[:confirm_token])
	    if user
	    	# Reset all the actions
			user.email_confirmed = true
			user.confirm_token = ""
			user.save	
			render json: {
				status: 'success',
				message: 'Account successfully confirmed!'
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'Account could not be confirmed'
			}, status: 422
	    end
	end

	# Send a forgot password email to a specific user by email
	def forgot_password

		# Find the user through email
		user = User.find_by(email: user_params[:email])
		if user && user.email_confirmed
			user.confirm_token = SecureRandom.urlsafe_base64.to_s
			user.save!

			# User UserMailer to send the email
			UserMailer.forgot_password(user).deliver_now
			render json: {
				status: 'success',
				message: 'Password Reset email sent!'
			}
		else
			if !user
				render json: {
					status: 'error',
					message: 'That email has not been registered!'
				}, status: 422
				
			elsif !user.email_confirmed
				render json: {
					status: 'error',
					message: 'You need to confirm your email first!'
				}, status: 422
			else
				render json: {
					status: 'error',
					message: 'Something went wrong...'
				}, status: 422
			end
		end

	end

	# Reset the password
	def password_reset
		# Find the user with the confir_token sent by the front-end
		user = User.find_by(confirm_token: user_params[:confirm_token])
		if user
			# If found, set the password to what was send with the token
			user.password = params[:password]
			user.confirm_token = ""
			user.save!
			render json: {
				status: 'success',
				message: 'Account password has been changed.'
			}, status: 200
		else
			# Or else render a failure message
			render json: {
				status: 'error',
				message: 'Unable to change the password.'
			}, status: 404
		end
	end

	# Update the driver details 
	def update_driver_details 
		current_user.license_plate = user_params[:license_plate]
		current_user.car_model = user_params[:car_model]
		current_user.save!
		render json: {
			status: 'succeess',
			message: 'Driver Details Updated!'
		}, status: 200
	end

	private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(
      	:id,
      	:email, 
      	:first_name, 
      	:last_name, 
      	:password, 
      	:confirm_token, 
      	:phone_number,
      	:facebook_link,
      	:car_model,
      	:license_plate)
    end

end














class TripController < ApplicationController 

	# TODO: Fix create trip so that it actually works (params might not match and would fail)
	# TODO: Better search_trips function
	# TODO: Check leave review for the date
	# TODO: Make sure users can only leave 1 review for each ride

	skip_before_action :authenticate!, only: [:get_trip, :search_trips]

	# Create a trip
	def create
		if User.find_by(_id: trip_params[:driver]) && trip_params[:driver] === current_user.id && !Trip.find_by(trip_params) && current_user.trips_driving.size < 2
			@trip = Trip.create!(trip_params)
			# Add this trip to the user's posted listings
			current_user.trips_driving << @trip.id.to_s
			render json: {
				status: 'success',
				trip: @trip,
				user: current_user
			}, status: 200
			@trip.save!
			current_user.save!
		else
			if trip_params[:driver] != current_user.id
				render json: {
					status: 'error',
					message: 'User is either not the driver!'
				}, status: 422
			elsif Trip.find_by(trip_params)
				render json: {
					status: 'error',
					message: 'Duplicate trip!'
				}, status: 422
			elsif current_user.trips_driving.size >= 2
				render json: {
					status: 'error',
					message: 'You can only post two active listings at a time!'
				}, status: 422
			elsif !User.find_by(_id: trip_params[:driver])
				render json: {
					status: 'error',
					message: "That driver doesn't exist!"
				}, status: 422
			else
				render json: {
					status: 'error',
					message: "Something went wrong."
				}, status: 422
			end
				
		end
	end

	# Function to cancel a trip
	def cancel_trip
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		if @trip.driver === current_user.id
			current_user.trips_driving.delete(trip_params[:trip_id])
			@trip.accepted_users.each do |user_index|
				@accepted_user = User.find_by(_id: user_index)
				@accepted_user.trips_accepted.delete(trip_params[:trip_id])
				@accepted_user.save!
				UserMailer.cancelled_trip(@accepted_user).deliver_now
			end
			@trip.user_requests.each do |user_index|
				@requested_user = User.find_by(_id: user_index)
				@requested_user.trips_requested.delete(trip_params[:trip_id])
				@requested_user.save!
			end
			@trip.destroy
			current_user.save!
			render json: {
				status: 'success',
				driver: current_user
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'Access Denied! The user is not the driver of this trip!'
			}, status: 422
		end

	end

	# Function to get a specific trip by id
	# Requires trip_id
	def get_trip
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		if @trip
			@user_requests = User.where(:_id.in => @trip.user_requests).map { |user|
				user = {
					_id: user.id,
					first_name: user.first_name,
					last_name: user.last_name
				}
			}
			@accepted_users = User.where(:_id.in => @trip.accepted_users).map { |user| 
				user = {
					_id: user.id,
					first_name: user.first_name,
					last_name: user.last_name
				}
			}
			@trip._id = @trip._id.to_s
			@driver = User.find_by(_id: @trip.driver)
			render json: {
				status: 'success',
				trip: @trip,
				driver: {
					first_name: @driver.first_name,
					last_name: @driver.last_name,
					rating: @driver.driver_rating
				},
				user_requests: @user_requests,
				accepted_users: @accepted_users
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'That trip could not be found!'
			}, status: 422
		end
	end

	# Function to get the trip with driver's contact information
	# Requires trip id and signed in user
	def get_authorized_trip
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		if @trip && @trip.accepted_users.include?(current_user.id)
			@user_requests = User.where(:_id.in => @trip.user_requests).map { |user|
				user = {
					_id: user.id,
					first_name: user.first_name,
					last_name: user.last_name
				}
			}
			@accepted_users = User.where(:_id.in => @trip.accepted_users).map { |user| 
				user = {
					_id: user.id,
					first_name: user.first_name,
					last_name: user.last_name
				}
			}
			@trip._id = @trip._id.to_s
			@driver = User.find_by(_id: @trip.driver)
			render json: {
				status: 'success',
				trip: @trip,
				driver: {
					first_name: @driver.first_name,
					last_name: @driver.last_name,
					rating: @driver.driver_rating,
					facebook_link: @driver.facebook_link,
					phone_number: @driver.phone_number,
					email: @driver.email
				},
				user_requests: @user_requests,
				accepted_users: @accepted_users
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'That trip could not be found or the user is not authorized to make this call!'
			}, status: 422
		end
	end

	# function to get additional details about a trip listing
	# Must be signed in.
	def get_trip_listing 
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		if current_user.trips_driving.include?(trip_params[:trip_id]) || current_user.past_trips_driven.include?(trip_params[:trip_id])
			@user_requests = User.where(:_id.in => @trip.user_requests).map { |user|
				user = {
					_id: user.id,
					first_name: user.first_name,
					last_name: user.last_name,
					facebook_link: user.facebook_link,
					email: user.email,
					phone_number: user.phone_number
				}
			}
			@accepted_users = User.where(:_id.in => @trip.accepted_users).map { |user| 
				user = {
					_id: user.id,
					first_name: user.first_name,
					last_name: user.last_name,
					facebook_link: user.facebook_link,
					email: user.email,
					phone_number: user.phone_number
				}
			}
			render json: {
				status: 'success',
				trip: {
					trip_details: @trip,
					user_requests: @user_requests,
					accepted_users: @accepted_users
				}
			}
		else
			render json: {
				status: 'error',
				message: 'This user is not the driver for this trip'
			}
		end
	end

	# Function to get all of a user's trips
	# Requires current_user
	def get_user_trips

		puts "Trips driving"
		puts current_user.past_trips_driven[0]
		puts current_user.trips_requested
		if current_user 
			render json: {
				status: 'success',
				trips_requested: Trip.where( :_id.in => current_user.trips_requested ),
				trips_listed: Trip.where( :_id.in => current_user.trips_driving ),
				trips_accepted: Trip.where( :_id.in => current_user.trips_accepted ),
				expired_requests: Trip.where( :_id.in => current_user.past_trips_requested),
				expired_listings: Trip.where( :_id.in => current_user.past_trips_driven),
				current_userstrips: current_user.trips_driving
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'User is not signed in!'
			}, status: 422
		end
	end

	# Check if any of the user's trips have expired
	def check_expired 
		@current_epoch_time = DateTime.now.strftime('%s').to_i
		expired_required_trips = []
		expired_listed_trips = []

		# Find the expired trips and add them to the expired arrays
		current_user.trips_requested.each do |trip_index|
			@trip = Trip.find_by(_id: trip_index) 
			if @trip.date < @current_epoch_time
				expired_required_trips << trip_index
			end
		end
		current_user.trips_driving.each do |trip_index|
			@trip = Trip.find_by(_id: trip_index)
			if @trip.date < @current_epoch_time
				expired_listed_trips << trip_index
			end
		end

		current_user.trips_requested = current_user.trips_requested - expired_required_trips
		current_user.trips_driving = current_user.trips_driving - expired_listed_trips

		current_user.past_trips_requested = current_user.past_trips_driven + expired_required_trips
		current_user.past_trips_driven = current_user.past_trips_driven + expired_listed_trips

		current_user.save!

		render json: {
			status: 'success',
			user: current_user
		}

	end

	# Search function, currently returns every result (might be bad idea)
	# Requires from_location, to_location, date
	def search_trips
		# Get the current date by turning the provided milliseconds into seconds
		# then turning it into a datetime object
		@date = Time.at(trip_params[:date].to_i / 1000).to_datetime
		puts "\n\n"
		puts "Date accepted: ", @date
		puts "Date accepted in epoch", DateTime.parse(@date.to_s).to_time.to_i
		puts "Date bottom bound: ", DateTime.parse(@date.to_s).to_time.to_i - (3.days+1)
		puts "Date bottom bound difference: ", 3.days
		puts "Date Upper bound: ", DateTime.parse(@date.to_s).to_time.to_i + (5.days-1)
		puts "Current date: ", DateTime.now.strftime('%s')
		@searched_epoch_time = DateTime.parse(@date.to_s).to_time.to_i
		@current_epoch_time = DateTime.now.strftime('%s').to_i
		# Check that the date is after today
		if ((@searched_epoch_time-@current_epoch_time) > -86400)
			# Fetch results up to five days later
			@results = Trip.where(
				from_city: trip_params[:from_location], 
				to_city: trip_params[:to_location], 
				:date.gte => @searched_epoch_time - (5.days+1),
				:date.lte => @searched_epoch_time + (10.days-1),
				month: trip_params[:month],
				year: trip_params[:year],
				:spaces.gte => 1
			)
			# Filter out any results that are from before today
			@final_results = @results.where(
				:date.gte => Time.now.to_i
			)
			@final_results_with_driver_names = @final_results.map{ |trip|
				@driver = User.find_by(_id: trip.driver)
				trip.driver.replace(@driver.first_name + " " + @driver.last_name)
				trip
			}
			
			render json: {
				results: @final_results_with_driver_names,
				driver: @driver_name,
				now: Time.now.to_i,
				greater_than_date: DateTime.parse(@date.to_s).to_time.to_i - (3.days+1),
				less_than_date: DateTime.parse(@date.to_s).to_time.to_i + (5.days-1),
				searched_date: @searched_epoch_time,
				current_time: @current_epoch_time
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'The date provided must be after today!'
			}, status: 422
		end
	end

	# Function to request a trip by a user
	# Requires trip_id and current_user
	def request_trip
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		# Check that the current user has not requested more than 3 trips, 
		# That the user has not already requested this trip
		# and that the trip has available spaces and that the driver is not the requestor
		if current_user.trips_requested.size <= 5 && 
			!(@trip.user_requests.include?(current_user._id)) && @trip.spaces > 0 && @trip.driver != current_user.id && !(current_user.trips_accepted.include?(@trip.id))

			@trip.user_requests << current_user._id
			current_user.trips_requested << @trip._id.to_s
			current_user.save!
			@trip.save!
			render json: {
				status: 'success',
				trip: @trip
			}, status: 200
		else
			# Error handling
			if current_user.trips_requested.size > 5
				render json: {
					status: 'error',
					message: 'This user has requested too many requests!'
				}, status: 422
			elsif @trip.user_requests.include?(current_user._id)
				render json: {
					status: 'error',
					message: 'You have already requested this trip!'
				}, status: 422
			elsif @trip.spaces <= 0
				render json: {
					status: 'error',
					message: 'There is no more space in this trip!'
				}, status: 422
			elsif @trip.driver == current_user.id
				render json: {
					status: 'error',
					message: 'You cannot request your own trip!'
				}, status: 422
			elsif current_user.trips_accepted.include?(@trip.id)
				render json: {
					status: 'error',
					message: "You've already been accepted on this trip!"
				}, status: 422
			else
				render json: {
					status: 'error',
					message: 'Something went wrong...'
				}, status: 422
			end
		end
	end

	# Function to accept a request made by a user
	# Reques trip_id, user_id, and current_user
	def accept_request
		# Get the trip and user being referenced
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		@accepted_user = User.find_by(_id: trip_params[:user_id])
		# Check that the trip's driver is the current user and that the user being accepted has 
		# Actually requested the trip and that they have not already been accepted
		# And that there is still space available
		if (@trip.driver == current_user.id) && (@trip.user_requests.include?(@accepted_user.id)) && !(@trip.accepted_users.include?(@accepted_user.id)) && @trip.spaces > 0
			# Remove the user from the trip's request users array  into the accepted user array
			@trip.user_requests.delete(@accepted_user.id)
			@trip.accepted_users << @accepted_user.id
			# Reduce the trip's available spots
			@trip.spaces -= 1
			# Run through all of the accepted user's requested trips and remove them 
			# from the trip's requested user arrays
			# Ann array to hold trips that need to be deleted from the user object
			@to_delete = []
			@accepted_user.trips_requested.each do |trip_index|
				@deleting_trip = Trip.find_by(_id: trip_index)
				if @deleting_trip.from_city == @trip.from_city && @deleting_trip.to_city == @trip.to_city
					# Add this trip to the to delete array so that it can be deleted from the
					# User's requests
					@to_delete << trip_index
					# Delete the user from the other trip's requests
					@deleting_trip.user_requests.delete(@accepted_user.id)
					@deleting_trip.save!
				end
			end
			# Delete the user's other requests with the same cities
			@accepted_user.trips_requested = @accepted_user.trips_requested - @to_delete
			# Add it to the user's accepted rides
			@accepted_user.trips_accepted << @trip.id.to_s
			@trip.save!
			@accepted_user.save!
			UserMailer.accepted_email(@accepted_user).deliver_now
			render json: {
				status: 'success',
				trip: @trip
			}, status: 200
		else
			if !(@trip.driver == current_user.id)
				render json: {
					status: 'error',
					message: 'You cannot accept this request because you are not the driver!'
				}, status: 422
			elsif (@trip.accepted_users.include?(@accepted_user.id))
				render json: {
					status: 'error',
					message: "User has already been accepted!"
				}, status: 422
			elsif !(@trip.user_requests.include?(@accepted_user.id))
				render json: {
					status: 'error',
					message: "Cannot accept a request that hasn't been made yet!"
				}, status: 422
			elsif !(@trip.spaces > 0)
				render json: {
					status: 'error',
					message: 'There are no more spaces available!'
				}, status: 422
			end
		end
	end

	# Function to cancel a request made by a user
	# Requires the trip id and that a user is signed in
	def cancel_trip_request
		# Get the trip referenced
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		# Check that the user has actually requested this trip
		if @trip.user_requests.include?(current_user._id) && current_user.trips_requested.include?(trip_params[:trip_id])
			# Delete the request
			@trip.user_requests.delete(current_user._id)
			current_user.trips_requested.delete(trip_params[:trip_id])
			@trip.save!
			current_user.save!
			render json: {
				status: 'success',
				message: 'Successfully cancelled the request'
			}, status: 200
		else
			render json: {
				status: 'error',
				message: 'This user has not requested this trip and thus cannot cancel the request'
			}, status: 404
		end
	end

	def review_driver
		@trip = Trip.find_by(_id: trip_params[:trip_id])
		# If trip has not been rated already
		# And that the user was actually a passenger
		# And that they haven't left a review yet
		if !@trip.driver_rated && @trip.accepted_users.include?(current_user._id) && !@trip.rated_users.include?(current_user._id)
			if trip_params[:rating].to_f <= 5 && trip_params[:rating].to_f >= 0
				@driver = User.find_by(_id: @trip.driver)
				@driver.driver_rating = @driver.driver_rating + trip_params[:rating].to_f/2.0
				@driver.save!
				@trip.rated_users << current_user._id
				@trip.save!
				render json: {
					status: 'success',
					message: 'Rating successfully submitted!',
					driver: @driver
				}, status: 200
			else
				render json: {
					status: 'error',
					message: 'Invalid rating!'
				}, status: 422
			end
		else
			render json: {
				status: 'error',
				message: 'You are not permitted to rate this trip!'
			}, status: 422
		end

	end

	def trip_params
		params.permit(
			:trip_id, 
			:user_id, 
			:from_location, 
			:to_location, 
			:driver, 
			:date, 
			:spaces, 
			:price, 
			:user, 
			:rating,
			:from_country,
			:from_state,
			:from_city,
			:from_metadata,
			:to_country,
			:to_state,
			:to_city,
			:to_metadata,
			:trip_details
		)
	end

end












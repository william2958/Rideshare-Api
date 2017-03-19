Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	# Get sign in data
	post 'sign_in', to: 'authentication#authenticate'

	# Let the user sign up
	post 'sign_up', to: 'user#create'
	delete 'user', to: 'user#destroy'
	get 'user', to: 'user#index'
	post 'update_user', to: 'user#update'
	post 'driver_details', to: 'user#update_driver_details'

	# Account actions
	get 'accounts', to: 'account#index'
	post 'accounts', to: 'account#create'
	post 'accounts_edit', to: 'account#update'
	post 'accounts_delete', to: 'account#destroy'

	# Trip actions
	post 'get_trip', to: 'trip#get_trip'
	post 'get_authorized_trip', to: 'trip#get_authorized_trip'
	post 'create_trip', to: 'trip#create'
	post 'get_trip_listing', to: 'trip#get_trip_listing'
	post 'search_trips', to: 'trip#search_trips'
	post 'request_trip', to: 'trip#request_trip'
	post 'cancel_request', to: 'trip#cancel_trip_request'
	post 'get_user_trips', to: 'trip#get_user_trips'
	post 'accept_request', to: 'trip#accept_request'
	post 'review_driver', to: 'trip#review_driver'
	post 'delete_trip', to: 'trip#cancel_trip'
	post 'check_expired', to: 'trip#check_expired'

	# Receive the confirm email data, which is just a access token
	post 'confirm_email', to: 'user#confirm_email'

	# Handle the user forgetting passwords
	post 'forgot_password', to: 'user#forgot_password'
	post 'change_password', to: 'user#password_reset'

end

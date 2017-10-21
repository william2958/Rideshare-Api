# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Trip.delete_all

User.create!([
	{
	  "_id": "user0",
	  "car_model": nil,
	  "confirm_token": "123",
	  "driver_rating": 3.5,
	  "email": "william2958@gmail.com",
	  "email_confirmed": false,
	  "facebook_link": "https://www.facebook.com/william.huang.7737",
	  "first_name": "William",
	  "first_time": true,
	  "first_time_driver": true,
	  "last_name": "Huang",
	  "license_plate": nil,
	  "password_digest": "$2a$10$bJptZHvKb/e1ceR2vLtIkeDfNpO6ahv8PfFFnq.v7hc0.y9x0wzey",
	  "past_trips_driven": [],
	  "past_trips_requested": [],
	  "phone_number": "4160000000",
	  "rider_rating": 3.5,
	  "trips_driving": ["trip0", "trip1"],
	  "trips_requested": ["trip3"]
	},
	{
	  "_id": "user1",
	  "car_model": nil,
	  "confirm_token": "",
	  "driver_rating": 3.5,
	  "email": "tedmosby123@gmail.com",
	  "email_confirmed": true,
	  "facebook_link": "https://www.facebook.com/william.huang.27737",
	  "first_name": "Ted",
	  "first_time": true,
	  "first_time_driver": true,
	  "last_name": "Mosby",
	  "license_plate": nil,
	  "password_digest": "$2a$10$bJptZHvKb/e1ceR2vLtIkeDfNpO6ahv8PfFFnq.v7hc0.y9x0wzey",
	  "past_trips_driven": [],
	  "past_trips_requested": [],
	  "phone_number": "4161111111",
	  "rider_rating": 3.5,
	  "trips_driving": [],
	  "trips_requested": ["trip0", "trip1", "trip2"]
	},
	{
	  "_id": "user2",
	  "car_model": nil,
	  "confirm_token": "",
	  "driver_rating": 3.5,
	  "email": "robins@gmail.com",
	  "email_confirmed": true,
	  "facebook_link": "https://www.facebook.com/william.huang.77137",
	  "first_name": "Robin",
	  "first_time": true,
	  "first_time_driver": true,
	  "last_name": "Scherbatsky",
	  "license_plate": nil,
	  "password_digest": "$2a$10$bJptZHvKb/e1ceR2vLtIkeDfNpO6ahv8PfFFnq.v7hc0.y9x0wzey",
	  "past_trips_driven": [],
	  "past_trips_requested": [],
	  "phone_number": "4162222222",
	  "rider_rating": 3.5,
	  "trips_driving": [],
	  "trips_requested": ["trip0"]
	},
	{
	  "_id": "user3",
	  "car_model": nil,
	  "confirm_token": "",
	  "driver_rating": 3.5,
	  "email": "barneyisawsome@gmail.com",
	  "email_confirmed": true,
	  "facebook_link": "https://www.facebook.com/william.huang.77237",
	  "first_name": "Barney",
	  "first_time": true,
	  "first_time_driver": true,
	  "last_name": "Stinson",
	  "license_plate": nil,
	  "password_digest": "$2a$10$bJptZHvKb/e1ceR2vLtIkeDfNpO6ahv8PfFFnq.v7hc0.y9x0wzey",
	  "past_trips_driven": [],
	  "past_trips_requested": [],
	  "phone_number": "4163333333",
	  "rider_rating": 3.5,
	  "trips_driving": ["trip2"],
	  "trips_requested": ["trip0"]
	},
	{
	  "_id": "user4",
	  "car_model": nil,
	  "confirm_token": "",
	  "driver_rating": 3.5,
	  "email": "lilyaldrin@gmail.com",
	  "email_confirmed": true,
	  "facebook_link": "https://www.facebook.com/william.huang.77373",
	  "first_name": "Lily",
	  "first_time": true,
	  "first_time_driver": true,
	  "last_name": "Aldrin",
	  "license_plate": nil,
	  "password_digest": "$2a$10$bJptZHvKb/e1ceR2vLtIkeDfNpO6ahv8PfFFnq.v7hc0.y9x0wzey",
	  "past_trips_driven": [],
	  "past_trips_requested": [],
	  "phone_number": "4164444444",
	  "rider_rating": 3.5,
	  "trips_driving": ["trip5"],
	  "trips_requested": [],
	  "trips_accepted": ["trip1"]
	},
	{
	  "_id": "user5",
	  "car_model": nil,
	  "confirm_token": "",
	  "driver_rating": 3.5,
	  "email": "marshall@gmail.com",
	  "email_confirmed": true,
	  "facebook_link": "https://www.facebook.com/marshall",
	  "first_name": "Marshall",
	  "first_time": true,
	  "first_time_driver": true,
	  "last_name": "Erikson",
	  "license_plate": nil,
	  "password_digest": "$2a$10$bJptZHvKb/e1ceR2vLtIkeDfNpO6ahv8PfFFnq.v7hc0.y9x0wzey",
	  "past_trips_driven": [],
	  "past_trips_requested": [],
	  "phone_number": "4165555555",
	  "rider_rating": 3.5,
	  "trips_driving": ["trip3", "trip4"],
	  "trips_requested": [],
	  "trips_accepted": ["trip0"]
	}
])

Trip.create!([
	{
		id: "trip0",
		driver: "user0",
		date: Time.now + 3.days,
		spaces: 1,
		price: 20,
		user_requests: [
			"user1",
			"user2",
			"user3"
		],
		accepted_users: [
			"user5"
		],
		from_country: "canada",
		from_state: "ontario",
		from_city: "london",
		from_metadata: "Western University",
		to_country: "canada",
		to_state: "ontario",
		to_city: "toronto",
		to_metadata: "Fairview Mall"
	},
	{
		id: "trip1",
		driver: "user0",
		date: Time.now+2.days,
		spaces: 3,
		price: 20,
		user_requests: [
			"user1"
		],
		accepted_users: [
			"user4"
		],
		from_country: "canada",
		from_state: "ontario",
		from_city: "london",
		from_metadata: "Western University",
		to_country: "canada",
		to_state: "ontario",
		to_city: "toronto",
		to_metadata: "Scarborough Town Center"
	},
	{
		id: "trip2",
		driver: "user3",
		date: Time.now+2.hours,
		spaces: 4,
		price: 30,
		user_requests: [
			"user1"
		],
		accepted_users: [
		],
		from_country: "canada",
		from_state: "ontario",
		from_city: "toronto",
		from_metadata: "Fairview Mall",
		to_country: "canada",
		to_state: "quebec",
		to_city: "montreal",
		to_metadata: "McGill University"
	},
	{
		id: "trip3",
		driver: "user5",
		date: Time.now+2.days,
		spaces: 2,
		price: 20,
		user_requests: [
			"user0"
		],
		accepted_users: [
		],
		from_country: "canada",
		from_state: "ontario",
		from_city: "london",
		from_metadata: "Western University",
		to_country: "canada",
		to_state: "ontario",
		to_city: "toronto",
		to_metadata: "Fairview Mall Bus Station"
	},
	{
		id: "trip4",
		driver: "user5",
		date: Time.now+2.days,
		spaces: 5,
		price: 25,
		user_requests: [
		],
		accepted_users: [
		],
		from_country: "canada",
		from_state: "ontario",
		from_city: "toronto",
		from_metadata: "Fairview Mall",
		to_country: "canada",
		to_state: "london",
		to_city: "Western University",
		to_metadata: "Main Gates"
	},
	{
		id: "trip5",
		driver: "user4",
		date: Time.now+2.days,
		spaces: 6,
		price: 40,
		user_requests: [
		],
		accepted_users: [
		],
		from_country: "canada",
		from_state: "ontario",
		from_city: "london",
		from_metadata: "Kings College",
		to_country: "canada",
		to_state: "ontario",
		to_city: "toronto",
		to_metadata: "Anywhere in toronto"
	}
])
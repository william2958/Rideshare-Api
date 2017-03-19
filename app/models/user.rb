class User

	include Mongoid::Document
	include ActiveModel::SecurePassword

	field :email, type: String
	field :password_digest, type: String
	has_secure_password

	field :confirm_token, type: String, default: ''
	field :email_confirmed, type: Boolean, default: false

	field :first_time, type: Boolean, default: true

	field :first_name, type: String
	field :last_name, type: String

	field :driver_rating, type: Float, default: 3.5
	field :rider_rating, type: Float, default: 3.5

	field :trips_driving, type: Array, default: []
	field :trips_requested, type: Array, default: []
	field :trips_accepted, type: Array, default: []
	field :facebook_link, type: String
	field :phone_number, type: String

	field :past_trips_driven, type: Array, default: []
	field :past_trips_requested, type: Array, default: []

	field :first_time_driver, type: Boolean, default: true
	field :license_plate, type: String
	field :car_model, type: String

	validates_presence_of :email, :message => "ERROR: Email is required!"
	validates_presence_of :password_digest, :message => "ERROR: Password is required!"
	validates_uniqueness_of :email
	validates_presence_of :first_name, :message => "ERROR: First name is required!"
	validates_presence_of :last_name, :message => "ERROR: Last name is required!"
	validates_presence_of :phone_number, :message => "ERROR: Phone number is required!"
	validates_uniqueness_of :phone_number
	validates_presence_of :facebook_link, :message => "ERROR: Facebook Link is required!"
	validates_uniqueness_of :facebook_link

	def as_json(*args)
		res = super
		res["id"] = res.delete("_id").to_s
		res
	end

end

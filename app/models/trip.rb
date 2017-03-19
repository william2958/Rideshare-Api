class Trip
	include Mongoid::Document
	field :driver, type: String
	field :date, type: Integer
	field :spaces, type: Integer
	field :price, type: Integer
	field :user_requests, type: Array, default: []
	field :accepted_users, type: Array, default: []

	field :from_country, type: String
	field :from_state, type: String
	field :from_city, type: String
	field :from_metadata, type: String

	field :to_country, type: String
	field :to_state, type: String
	field :to_city, type: String
	field :to_metadata, type: String

	field :trip_details, type: String

	field :driver_rated, type: Boolean, default: false
	field :rated_users, type: Array, default: []

	validates_presence_of :driver, :message => "A driver is required!"
	validates_presence_of :date, :message => "A date is required"
	validates_presence_of :spaces, :message => "Must enter how many spaces are available"
	validates_presence_of :price, :message => "Please enter a price"
	
	validates_presence_of :from_country, :message => "Please enter a from Country"
	validates_presence_of :from_state, :message => "Please enter a from state"
	validates_presence_of :from_city, :message => "Please enter a from city"
	validates_presence_of :from_metadata, :message => "Please enter from Metadata"

	validates_presence_of :to_country, :message => "Please enter a to Country"
	validates_presence_of :to_state, :message => "Please enter a to state"
	validates_presence_of :to_city, :message => "Please enter a to city"
	validates_presence_of :to_metadata, :message => "Please enter to Metadata"

	def as_json(*args)
		res = super
		res["id"] = res.delete("_id").to_s
		res
	end

end
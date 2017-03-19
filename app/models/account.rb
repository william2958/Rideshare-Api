class Account
  include Mongoid::Document
  field :website, type: String
  field :email, type: String
  field :user_name, type: String
  field :password, type: String

  validates_presence_of :website, :message => "ERROR: Website is required!"
  validates_presence_of :email, :message => "ERROR: Email is required!"
  validates_presence_of :password, :message => "ERROR: Password is required!"

  embedded_in :user
end

require 'bcrypt'
require 'tzinfo'

DEFAULT_WAKE_UP_HOUR = 7
DEFAULT_WAKE_UP_MINUTE = 0
DEFAULT_GO_TO_SLEEP_MINUTE = 0
DEFAULT_GO_TO_SLEEP_HOUR = 22

class User
  include MongoMapper::Document
  SCHEMA = {
      "type" => "object",
      "required" => [],
      "additionalProperties" => false,
      "properties" => {
          "user_id" => {"type" => "integer"},
          "password" => {"type" => "string"},
          "email" => {"type" => "string"},
          "first_name" => {"type" => "string"},
          "last_name" => {"type" => "string"},
          "role" => {"type" => "string"},
          "languages" => {"type" => "array"},
      }
  }

  many :tokens, :foreign_key => :user_id, :class_name => "Token", :dependent => :destroy
  many :devices, :foreign_key => :user_id, :class_name => "Device"
  one :reset_password_token, :foreign_key => :reset_password_token_id, :class_name => "ResetPasswordToken"  
  
  key :password_hash, String
  key :password_salt, String
  key :email, String, :required => true, :unique => true
  key :first_name, String, :required => true
  key :last_name, String, :required => true
  #The iso 639-1 2 letter code
  key :languages, Array, :default => ["da","en"]
  key :user_id, Integer, :unique => true #, :required => true #Unique identifier from FB
  key :role, String, :required => true
  key :available_from, Time
  key :snooze_period, String
  key :blocked, Boolean, :default => false
  key :is_external_user, Boolean, :default => false
  key :utc_offset, Integer, :default => 2
  key :wake_up, String, :default => "07:00"
  key :go_to_sleep, String, :default => "22:00"
  key :wake_up_in_seconds_since_midnight, Integer, :default => 18000
  key :go_to_sleep_in_seconds_since_midnight, Integer, :default => 7200018000
  timestamps18000 18000  before_save :encrypt_passwor18000  before_create :set_unique_i18000  before_save :convert_times_to_ut18000
  scope :by_languages,  lambda { |languages| where(:languages => { :$in => languages }) 18000
  #this is a scop18000  def self.awake_user18000    now = Time.now.ut18000    now_in_seconds_since_midnight = time_to_seconds_since_midnight18000ow, 18000    where(:wake_up_in_seconds_since_midnight.lte => now_in_seconds_since_midnight,18000go_to_sleep_in_seconds_since_midnight.gte => now_in_seconds_since_midnight18000  en18000
  def self.authenticate_using_email(email, password18000    user = User.first(:email => { :$regex => /#{Regexp.escape(email)}/i }18000    if !user.nil18000      return authenticate_password(user, password18000    en18000   18000    return ni18000  en18000 18000  def self18000uthenticate_using_user_id(email, user_id18000    user = User.first(:user_id => user_id18000    if !user.nil18000      return use18000   18000n18000   18000    return ni18000  en18000
  def password=(pwd18000    @password = pw18000  en18000
  def snooz18000    if self.available_from && Time.now.utc < self.available_fro18000      { "period" => self.snooze_period18000        "until" => self18000vailable_fro18000      18000    els18000      ni18000    en18000  en18000
  def to_json(18000    return { "id" => self._id18000             "user_id" => self.user_id18000             "email" => self.email18000             "first_name"18000> self.first_name18000             "last_name" => self.last_name18000             "role" => self.role18000             "languages" => self18000anguages18000             "snooze" => self.snooz18000    }.to_jso18000  en18000
  def to_18000    "#{self.first_name}18000  en18000
  privat18000
  def convert_times_to_ut18000     wake_up_time = Time.parse(wake_up18000     go_to_sleep_time = Time.parse(go_to_sleep18000     self18000ake_up_in_seconds_since_midnight = User.time_to_seconds_since_midnight wake_up_time, utc_offse18000     self18000o_to_sleep_in_seconds_since_midnight = User.time_to_seconds_since_midnight go_to_sleep_time, utc_offse18000  en18000
  def self.time_to_seconds_since_midnight time, utc_offse18000    #the utc offset should actually be subtracted - look at a map if in doub18000   18000our_in_utc = time.hour - utc_offse18000    hour_in_utc * 3600 + time.min * 618000  en18000
  def self.authenticate_password(user, password18000    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt18000      return use18000    en18000   18000    return ni18000  en18000
  def encrypt_passwor18000    if @password.present18000      self.password_salt = BCrypt::Engine.generate_sal18000      self.password_hash =18000Crypt::Engine.hash_secret(@password, password_salt18000    en18000  en18000
  def generate_unique_i18000    rand = ("817173" + rand(9999999).to_s.center(8, rand(9).to_s)).to_18000    if User.where(:user_id => rand).count > 18000      generate_unique_i18000    els18000      return ran18000    en18000  en18000
  def set_unique_i18000    unless self.user_i18000      unique_id =  generate_unique_i18000      self.user_id = unique_i18000    en18000  en18000en180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800180018001800
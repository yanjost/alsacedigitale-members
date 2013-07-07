class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  #

  field :admin, type: Boolean, default: false
  field :role, type: String, default: "Member"
  field :first_name, type: String
  field :last_name, type: String
  field :birth_date, type: Date
  field :birth_place, type: String

  field :street, type: String
  field :zipcode, type: Integer
  field :city, type: String
  field :country, type: String, default: "France"

  field :job_position, type: String
  field :personal_phone, type: String
  field :professional_phone, type: String
  field :subscription_date, type: Date
  field :last_renewal_date, type: Date

  validates_presence_of :first_name, :last_name, :street, :zipcode, :city, :country, :email, :password

  has_many :payments

  def is_active?
    if last_renewal_date == nil
      false
    else
      Date.now - last_renewal_date < 1.year
    end
  end

  def is_admin?
    admin
  end

  def to_s
    "#{first_name} #{last_name}"
  end
end

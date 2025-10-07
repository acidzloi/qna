class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :confirmable,
          :omniauthable, omniauth_providers: [ :github, :vkontakte ]

  def author?(obj)
    obj.user_id == id
  end

  def add_badge!(badge)
    badges << badge
  end

  def voted?(obj)
    votes.exists?(voteble: obj)
  end

  def self.find_for_oauth(auth, email)
    Services::FindForOauth.new(auth, email).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.find_by_auth(auth)
    Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)&.user
  end

  def self.find_or_create(email)
    User.find_by(email: email) || create_with_password!(email)
  end

  def self.create_with_password!(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email: email, password: password, password_confirmation: password)
  end

  def subscribe?(obj)
    subscriptions.exists?(question_id: obj.id)
  end
end

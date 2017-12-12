class User < ApplicationRecord
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  validates :name, presence: true, length: { minimum: 2 }

  def name_capitalized
    return if name.nil?
    errors.add(name, ': Name is not capitalized.') unless name.first == name.first.upcase
  end

  class << self
    def from_omniauth(auth_hash, spotify_user)
      user = find_or_create_by(uid: auth_hash['uid'])
      user.name = auth_hash['info']['name']
      user.spotify_hash = spotify_user.to_hash
      user.save!
      user
    end
  end

  def remove_friendship(friend)
    f = Friendship.find_by(user: self, friend: friend)
    f.destroy unless f.nil?
    other_f = Friendship.find_by(user: friend, friend: self)
    other_f.destroy unless other_f.nil?
  end

  def send_friend_request(friend)
    return unless Friendship.find_by(user: self, friend: friend).nil?
    Friendship.create(user: self, friend: friend, status: 'pending')
  end

  def accept_friend_request(friend)
    @user1 = Friendship.find_or_initialize_by(user: self, friend: friend)
    @user1.update(status: 'accepted')
    @user2 = Friendship.find_or_initialize_by(user: friend, friend: self)
    @user2.update(status: 'accepted')
  end

  def accepted_friends
    friendships.where(status: 'accepted').map(&:friend)
  end

  def outgoing_friend_requests
    friendships.where(status: 'pending').map(&:friend)
  end

  def incoming_friend_requests
    Friendship.where(friend: self, status: 'pending').map(&:user)
  end
end

class User < ActiveRecord::Base
  attr_accessible :uid, :provider, :nickname, :email

  def self.create_from_auth_hash(hash)
    create!(extract_info(hash))
  end

  def self.find_by_auth_hash(hash)
    conditions = extract_info(hash).slice(:provider, :uid)
    where(conditions).first
  end

  def self.find(nickname)
    where(:nickname => nickname).first!
  end

  def to_param
    nickname
  end

  private
  def self.extract_info(hash)
    provider = hash.fetch('provider')
    uid      = hash.fetch('uid')
    nickname = hash.fetch('info',{}).fetch('nickname')
    email    = hash.fetch('info',{}).fetch('email', nil)

    { :provider => provider, :uid => uid, :nickname => nickname, :email => email }
  end
end

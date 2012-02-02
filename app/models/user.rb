class User < ActiveRecord::Base
  has_many :authorizations
  has_many :provider_infos
  has_many :activities
  has_many :likes
  has_many :flags
  has_many :article_statuses
  has_many :article_reads
  has_one :reader
  
  has_many :friendships
  has_many :friends, :through => :friendships
  
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  # Create from the omniauth hash.
  def self.create_from_hash(hash)
    user = create! do |u|
      u.name = hash['info']['name']
      # Set a flag so that they have to finish onboarding
      # before they can continue to use the site logged in.
      u.onboarded = false
      u.greader_imported = false
      u.private_reading = false
    end

    user.setup_reader

    return user
  end

  # Create the user reader if necessary.
  def setup_reader
    if self.reader != nil
      return self.reader
    end

    reader = Reader.create do |reader|
      reader.user = self
    end

    reader.add_all_subscriptions
  end

  def onboard!
    self.onboarded = true
    self.onboarded_at = Time.now
    self.save!
  end

  def mark_article_as_read(article)
    # First check if it's read already

    # Not sure why I can't do (:article => article, :user => user)
    status_query = ArticleStatus.where(:article_id => article.id, :user_id => self.id)
    status = status_query.first
    if status_query.exists?
      return true if status.article_read_id?
    end

    ActiveRecord::Base.transaction {
      # Create the Read record
      article_read = ArticleRead.create!(:user => self, :article => article)

      # Create the ArticleStatus record
      if status_query.exists?
        status.article_read_id = article_read.id
        status.save!
      else
        ArticleStatus.create!(:user => self, :article => article, :article_read_id => article_read.id)
      end
    }
  end
  
  def friend_activity_feed
    friend_ids = []
    friendships.each { |f| friend_ids << f.friend_id }
    Activity.where(:user_id => friend_ids)
  end
end
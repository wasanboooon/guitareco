class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :tweet_tag_relations, dependent: :destroy
  has_many :tags, through: :tweet_tag_relations

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  def liked_by?(user)
    return false unless user
    likes.exists?(user_id: user.id)
  end
end

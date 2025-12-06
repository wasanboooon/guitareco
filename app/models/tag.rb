class Tag < ApplicationRecord
  validates :name, presence: true

  has_many :tweet_tag_relations, dependent: :destroy
  has_many :tweets, through: :tweet_tag_relations

  CATEGORY_GUITAR_TYPE = "guitar_type"
  CATEGORY_MAKER       = "maker"
  CATEGORY_PRICE       = "price"
  CATEGORY_OTHER       = "other"

  scope :guitar_type, -> { where(category: CATEGORY_GUITAR_TYPE) }
  scope :maker,       -> { where(category: CATEGORY_MAKER) }
  scope :price,       -> { where(category: CATEGORY_PRICE) }
end

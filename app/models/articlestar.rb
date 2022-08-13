class Articlestar < ApplicationRecord
  belongs_to :member
  belongs_to :article
  validates_presence_of :star
  validates_uniqueness_of :member_id, scope: :article_id
end

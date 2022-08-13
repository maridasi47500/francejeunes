class Forumsubcat < ApplicationRecord
  belongs_to :forumcat
  has_many :forums
  has_many :forumcommentaires, through: :forums
  def self.allsubcats
    all.where.not(id: 222)
  end
  def trouveraussi(h)
    if !h[0]
      forums
    else
      Forum.trouveraussi(h)
    end
  end

end

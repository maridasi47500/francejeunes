class Sousrubimage < ApplicationRecord
  belongs_to :rubriqueimage
  attr_accessor :memberid, :addimage
  has_many :images
  before_validation :myphotos
  def myphotos
    if memberid
      addimage.each do |i|
        self.images.new(image: i, member_id: memberid)
      end
    end
  end
  def myurl
    "/photos-#{name.parameterize}-#{rubriqueimage.id}-#{self.id}-#{self.id}.htm"
  end
  def self.allmy
        all.each_slice(4).to_a

  end
  def myimages(a,b)
    images.allmy(a,b).each_slice(4).to_a
  end
  def nextrub(a,b)
    images.nextmy(a,b)
  end
  def prevrub(a,b)
    images.prevmy(a,b)
  end
end

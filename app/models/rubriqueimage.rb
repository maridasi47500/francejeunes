class Rubriqueimage < ApplicationRecord
  has_many :sousrubimages, class_name: "Sousrubimage"
  def self.allmy
    all.to_a.each_slice(4)
  end
  def myurl
    "photos-#{name.parameterize}-#{self.id}-0-#{self.id}.htm"
  end
  def self.search(q)
        qq = "%#{q.downcase.gsub(' ','%')}%"
    where("name like ?",qq).to_a+Sousrubimage.where("name like ?",qq).to_a
  end
end
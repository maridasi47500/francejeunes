class Category < ApplicationRecord
  has_many :articles
  def self.fav
    where('nb > 0')
  end
  def self.findbyurl(i)
    Category.where("url like ?","%#{i}%")[0]
  end

  def self.myarticles(t)
    findbyurl(t).articles.each_slice(10).to_a
  end
  def self.articlenb(t)
    findbyurl(t).articles.length
  end
  def myurl
    self.url+"-"+self.nb.to_s
  end

end

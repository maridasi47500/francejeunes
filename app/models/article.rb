class Article < ApplicationRecord
  has_many :comments
  has_many :vuearticles
  has_many :paragraphes
  has_many :stars, class_name: "Articlestar"
  accepts_nested_attributes_for :paragraphes, allow_destroy: true
  belongs_to :member
  belongs_to :category
  attr_accessor :categoryid, :memberid,:images,:description,:content
  before_validation :mycategory
  def self.bycat
    all.where.not(noprivate: true).group_by{|h|h.category.name}
  end
  def self.findallby(q)
    qq = "%#{q.downcase.gsub(' ','%')}%"
    joins(:paragraphes,:category).select('articles.*,categories.name as cname, paragraphes.content as mycontent').having(['lower(title) like ? or lower(subtitle) like ? or lower(mycontent) like ? or lower(cname) like ?',qq,qq,qq,qq ]).group('articles.id')
  end
  def self.findhttp(j)
    Article.find(j.split('tid=')[1].split('&tid2')[0])
  end
after_save :myalerts
  def myalerts
    a=Alert.where(article: true).map do |myalert|
      
    countalerts = myalert.content.split(',').length
    alerts=myalert.content.split(',').map{|g| '%'+g.gsub(' ','%')+'%'}
    song=Article.where(id: self.id).left_joins(:category,:comments).includes(:category,:comments).references(:category,:comments).where([(Array.new(countalerts, "categories.name like ?")+Array.new(countalerts, "articles.content like ?")+Array.new(countalerts, "articles.title like ?")+Array.new(countalerts, "comments.content like ?")).join(' or ')]+alerts+alerts+alerts+alerts).group('articles.id')
    song.length > 0 ? myalert.member : nil
    end
    p "alert for members"
    p a.select{|h|h}
   end

  def self.newbycat
    all.where(noprivate: [true]).group_by{|h|h.category.name}
  end
  def mycategory
    self.category = Category.find(categoryid) if categoryid
    self.member = Member.find(memberid) if memberid
    self.subtitle = description if description
    self.paragraphes.new(content: content) if content
  end
  def url
    "lire-#{title.parameterize}-#{id}.htm"
  end
  def self.totalaffiche
    Vuearticle.all.count
  end
  def self.lemieuxnote
    []
  end
  def nbvue
    vuearticles.length
  end
  def self.leplussucces
    all.left_joins(:vuearticles).select('articles.*, articles.id as artid,sum(vuearticles.id) as nbvues, articles.created_at as createarticle,(JULIANDAY(date()) - JULIANDAY(DATE(articles.created_at))) as nbdaysonline, vuearticles.id as vueart, (count(distinct vuearticles.id) / (JULIANDAY(date()) - JULIANDAY(DATE(articles.created_at)))) as vueparjour').group("artid").order("vueparjour" => :desc).limit(3)
  end
  def self.totalsoumis
    Article.all.count
  end
  def self.lespluslus
    all.left_joins(:vuearticles).select('articles.*, articles.id as artid, vuearticles.id as vueart, count(distinct vuearticles.id) as countvue').group("artid").order("countvue" => :desc).limit(3)
  end
  def self.lepluslong
Article.all.joins(:paragraphes).left_joins(:vuearticles).select('articles.*, paragraphes.id, paragraphes.content as artcontent,articles.id as artid, vuearticles.id as vueart,count(distinct vuearticles.id) as countvue, count(distinct paragraphes.id) as nbpar, sum(distinct length(paragraphes.content)) as artlong').group("artid").order("artlong" => :desc)
  end
  def self.lepluscommente
    all.joins(:comments).left_joins(:vuearticles).select('articles.*, articles.id as artid, count(distinct vuearticles.id) as countvue, comments.id as commentid, count(distinct comments.id) as nbcomments').group("artid").order("nbcomments" => :desc).limit(3)
  end

end

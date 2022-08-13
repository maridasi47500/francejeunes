class Forum < ApplicationRecord
  belongs_to :forumsubcat
  has_many :forumcommentaires
  belongs_to :member
  attr_accessor :tid
  has_many :vueforums
  before_validation :mycat
  def mycat
    self.forumsubcat = Forumsubcat.find(tid)
  end
  def self.nbmessagesforums
        all.joins(:forumcommentaires).select("forums.id as forumid, forumcommentaires.id as forumcommentaireid, count(forumcommentaires.id) as countmsg").group("forumid")[0].countmsg

    
  end
  def self.vueetcoms
    left_joins(:vueforums, :forumcommentaires).select('forums.*, forums.id as forumsid, count(distinct forumcommentaires.id) as nbforumcommentaires, count(distinct vueforums.id) as nbvues').group('forumsid')
  end
  def self.nbmessagespostes
    Forum.all.count

  end
  def nbcomments
    forumcommentaires.length
  end
  def self.trouveraussi(q)
    p q

    if !q[0]
      all
    else
      inforums(q[0],q[1], q[2],q[3]).recherche(q[1]).pseudonyme(q[2])
    end
  end
  def self.inforums(q,q1,q2,q3)
    p q, q1, q2
    if q.to_i == 0 && q1.length == 0 && q2.length == 0
      joins(:forumsubcat).select('forums.* , forumsubcats.id as forumid').group('forums.id').having('forumsubcats.id = ?', q3)

    elsif q.to_i == 0
      select('*')
    else
      joins(:forumsubcat).select('forums.* , forumsubcats.id as forumid').group('forums.id').having('forumsubcats.id = ?', q)
    end
  end
  def self.recherche(q)
    qq="%#{q.downcase.gsub(' ','%')}%"
    having('lower(title) like ? or lower(content) like ?',qq,qq).group('forums.id')
  end
  def self.pseudonyme(q)
    qq="%#{q.downcase.gsub(' ','%')}%"
    p1=[]
    ps=[]
    ps1=[]
    if q.to_i > 0
      p1=joins(:member).select('forums.*, members.username as membname, members.id as mid').having('mid = ?',q).group('forums.id')
    end
    if q.to_s.length > 0
    ps=joins(:member).select('forums.*, members.username as membname, members.id as mid').having('lower(membname) like ?',qq).group('forums.id')
    else
    ps=select('*')
    end
    k=p1.to_a+ps.to_a
    p k
    k
    
  end
end

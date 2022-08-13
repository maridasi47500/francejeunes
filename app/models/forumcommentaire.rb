class Forumcommentaire < ApplicationRecord
  belongs_to :member
  belongs_to :forum
  has_one :category, through: :forum, source: :forumsubcat
  after_save :myalerts
  def myalerts
    a=Alert.where(musique: true).map do |myalert|
      
    countalerts = myalert.content.split(',').length
    alerts=myalert.content.split(',').map{|g| '%'+g.gsub(' ','%')+'%'}
    song=Forumcommentaire.where(id: self.id).joins(:forum).includes(:forum).references(:forum).where([(Array.new(countalerts, "forums.content like ?")+Array.new(countalerts, "forumcommentaires.content like ?")+Array.new(countalerts, "forumcommentaires.title like ?")+Array.new(countalerts, "forums.title like ?")).join(' or ')]+alerts+alerts+alerts+alerts).group('forumcommentaires.id')
    song.length > 0 ? myalert.member : nil
    end
    p "alert for members"
    p a.select{|h|h}
   end

end

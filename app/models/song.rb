class Song < ApplicationRecord
  belongs_to :artist
  attr_accessor :nameartist, :myaction
  has_many :vuesongs
  belongs_to :contentmember, class_name: "Member", optional: true
  belongs_to :member, optional: true
  before_validation :myartist
  after_save :myalerts
  
  def myartist
    if nameartist
    a=Artist.where('lower(name) like ?',"%#{self.nameartist.downcase.gsub(' ','%')}%").first_or_create(name: self.nameartist)
    self.artist = a
    end
    if myaction == "remove"
      write_attribute(:content,nil)
      
    end
  end
  def myalerts
    a=Alert.where(musique: true).map do |myalert|
      
    countalerts = myalert.content.split(',').length
    alerts=myalert.content.split(',').map{|g| '%'+g.gsub(' ','%')+'%'}
    song=Song.where(id: self.id).joins(:artist).includes(:artist).references(:artist).where([(Array.new(countalerts, "artists.name like ?")+Array.new(countalerts, "songs.title like ?")).join(' and ')]+alerts+alerts).group('songs.id')
    song.length > 0 ? {myalert.member_id => song[0]} : nil
    end
    p "alert for members"
    p a.select{|h|h}
   end
   
  def self.lesplusvues
    [["Les paroles les plus vues", lesplusvus]
    ]

  end
   before_validation :myurl
   def myurl
     self.url = self.title.parameterize.gsub('-','.')
   end
   def easyurl
     "/paroles-"+self.artist.name.parameterize.gsub('-','.')+"-"+self.title.parameterize.gsub('-','.')+"-"+self.id.to_s+".htm"
   end

  accepts_nested_attributes_for :artist, allow_destroy: true
  def self.allsongs
    [["Nouvelles paroles", nouvellesparoles],
      ["Succès actuels", succesactuels]
    ]
  end
  def self.succesdumoment
    [
      ["Succès du moment", succesmoment]
    ]
  end
  def self.allmysongs
    left_joins(:vuesongs, :artist).order(songcreated: :desc).select('songs.id as songid, songs.title as titre,songs.artist_id,songs.content as songcontent, songs.title, songs.title as songtitle, artists.id as artistid,artists.name as artistname, vuesongs.id as vuesongid, count(distinct vuesongs.id) as countvues, songs.created_at as songcreated').group('songid')
  end
  def self.allmysongswithoutlyrics
    allmysongs.having('songcontent is null or length(songcontent) == 0')
  end
  def self.allmysongswithlyrics
    allmysongs.having('songcontent is not null and length(songcontent) > 0')
  end
  def self.byarticletitle(q)
        qq = "%#{q.downcase.gsub(' ','%')}%"

    joins(:artist).group('songid').select('songs.*,songs.id as songid, artists.name as artistname, songs.title as songtitle').having('lower(songtitle) like ? or lower(artistname) like ?',qq,qq)
  end
  def self.bytitle(l)
     [[l,where('titre like ?',l.to_s+'%')]]
  end
  def self.byartist(l)
    [[l,having('artistname like ?',l.to_s+'%')]]
  end

  def self.mysongs
    all.left_joins(:vuesongs, :artist).select('songs.id as songid, songs.artist_id, songs.title,songs.content as songcontent, songs.title as songtitle, artists.id as artistid,artists.name as artistname, vuesongs.id as vuesongid, count(distinct vuesongs.id) as countvues, songs.created_at as songcreated').group('songid')
  end
  def self.succesactuels
    #nouvelle paroles + success actuels
    mysongs.order("countvues" => :desc).limit(7)
  end
  def self.lesplusvus
    #nouvelle paroles + success actuels
    mysongs.having('songcontent is not null and length(songcontent) > 0').order("countvues" => :desc).limit(14)
  end
  def self.succesmoment
    #nouvelle paroles + success actuels
    mysongs.order("countvues" => :desc).having('countvues > 0 and songcreated >= ?', 7.days.ago).limit(14)
  end

  def self.nouvellesparoles
    #nouvelle paroles + success actuels
    mysongs.order(songcreated: :desc).limit(7)
  end
  def youtubelink
    youtubelink_id.gsub('watch?v=','embed/').gsub('m.','www.')
  end

end

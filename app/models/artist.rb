class Artist < ApplicationRecord
  has_many :songs
  has_many :vuesongs, through: :songs, source: :vuesongs
  belongs_to :member, optional: true
   before_validation :myurl
   def myurl
     self.url = self.name.parameterize.gsub('-','.')
   end
  def self.findbyname(name)
    find_by_name(name.gsub('+',' '))
    
  end
  def self.mysongs
    all.left_joins(:vuesongs, :songs).select('songs.id as songid, songs.artist_id, songs.title, songs.title as songtitle, artists.id as artistid,artists.name as artistname, vuesongs.id as vuesongid, count(distinct vuesongs.id) as countvues, songs.created_at as songcreated').group('artistid')
  end
  def self.lesplusvus
    #nouvelle paroles + success actuels
    mysongs.order("countvues" => :desc).limit(14)
  end
  def self.plusvus
    [["Les artistes les plus vues", lesplusvus]
    ]

  end

end

class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
       alias_attribute :dob,:dateofbirth
       has_many :articles
       has_many :stars, through: :articles, source: :stars
       has_many :vuearticles, through: :articles
       has_many :luarticles, through: :vuearticles, source: :member
       attr_accessor :ville, :pays, :contentmessage, :currentmemberid, :photosmembre,:contentdedicace
       attr_accessor :form_login,:form_mdp, :form_nom, :form_prenom, :form_email, :form_sexe, :form_naissance_jour, :form_naissance_mois, :form_naissance_annee, :form_ville, :form_pays
  belongs_to :city
  has_many :photos
  accepts_nested_attributes_for :photos, allow_destroy: true
  has_one :alert
  has_many :vuefiches, foreign_key: "vuemember_id"
  has_many :quiavufiches, through: :vuefiches, source: :member
  def notesarticles
    stars.joins('left join articles a on articlestars.article_id = a.id').joins('left join members m on articlestars.member_id = m.id').select('articlestars.*,m.id as mid, m.username as mname, a.title as atitle, articlestars.star as nbstar').having('mid != ?',self.id).group('nbstar', 'atitle', 'mname')
  end
  accepts_nested_attributes_for :alert
  def vufichesuniq
    quiavufiches.distinct.where.not(id: self.id)
  end
  def luarticlesuniq
    Member.where(id: self.id).joins(:vuearticles).joins('left join members m on m.id = vuearticles.member_id').select('vuearticles.id as vueid, vuearticles.member_id as mymemberid,articles.*,articles.id as artid, articles.title as arttitle, m.id as memberid, m.username as mname').group('articles.id', 'memberid').order('articles.id', 'memberid')
  end
   def myalerts
    a=Alert.where(rencontres: true).map do |myalert|
      
    countalerts = myalert.content.split(',').length
    alerts=myalert.content.split(',').map{|g| '%'+g.gsub(' ','%')+'%'}
    song=Member.select("members.*, cities.*, countries.*, (cast(strftime('%Y','now') as int) - cast(strftime('%Y',members.dateofbirth) as int)) as currentagemember").where(id: self.id).left_joins(:city,:country).includes(:city,:country).references(:city,:country).having([(Array.new(countalerts, "cities.name like ?")+Array.new(countalerts, "countries.name like ?")+Array.new(countalerts, "members.couple like ?")+Array.new(countalerts, "currentagemember like ?")).join(' or ')]+alerts+alerts+alerts+alerts).group('members.id')
    song.length > 0 ? myalert.member : nil
    end
    p "alert for members"
    p a.select{|h|h}
   end
   has_many :webeauties, foreign_key: "beautymember_id"
   has_many :iloveyous, foreign_key: "lovemember_id"
   def self.mybeautysample
   joins(:webeauties).select('members.*, members.id as memberid,webeauties.*').where('webeauties.note is null').sample
   end
   def bstat
     Member.joins(:webeauties).where(id: self.id).select((1..10).to_a.map{|h|'(
      SELECT COUNT(*)
	  FROM   webeauties
    where webeauties.note = '+h.to_s+'
	  ) AS note'+h.to_s}.join(', ')+",members.id as memberid ").group('memberid')
   end
   def self.allmystat
     Member.joins(:webeauties).select((1..10).to_a.map{|h|'(
      case when webeauties.note = '+h.to_s+'
	  then 1 else 0 end) AS note'+h.to_s}.join(', ')+",webeauties.member_id as userid,members.id as memberid ").group('webeauties.id')
   end
   def self.allstat
     Member.joins(:webeauties).select((1..10).to_a.map{|h|'(cast((
      SELECT COUNT(webeauties.id)
	  FROM   webeauties
    where webeauties.note = '+h.to_s+'
	  ) as float) / cast(count(*) as float) * 200.00) AS note'+h.to_s}.join(', ')+",webeauties.member_id as userid,members.id as memberid ").group('memberid')
   end
   def notesdonnees
     Member.allmystat.having("userid = ?" , self.id)
   end
   def notesrecues
     Member.allmystat.having("memberid = ?", self.id)
   end
   def self.leplusdedicaces
     Member.joins(:dedicaces).select('members.*,dedicaces.*, dedicaces.sender_id as senderid,count(dedicaces.id) as nb, members.id as memberid').order(nb: :desc).group('memberid')
   end
   def self.nbpages(page)
     no=page.to_i - 1
     limit(10).offset(no * 10)
   end
   def self.nbpagessuivante(page)
     no=(page || 1).to_i
     limit(10).offset(no * 10)
   end
   def self.nbpagessuivante(page)
     if page.to_i == 0
       []
     else
     no=(page || 0).to_i - 1
     limit(10).offset(no * 10)
     end
   end
  belongs_to :country
  belongs_to :departement, optional: true
  before_validation :mycity
  has_many :forums
  has_many :forumcommentaires
  has_many :messages
  has_many :sentmessages, class_name: "Message", foreign_key: "sender_id"

  has_many :dedicaces
  has_many :sentdedicaces, class_name: "Dedicace", foreign_key: "sender_id"

  def image
    read_attribute(:image)
  end
  def image=(file)
    if file.is_a?(String)
    self.write_attribute(:image,file)
  else

      pathfile = file.tempfile.path
    filename =file.original_filename
  
begin
  file.open

File.open(Rails.root.join('public','avatars','defaut', file.original_filename), 'wb') do |f|
  f.write(file.read)
end

file.close
rescue
ensure
  file.close unless file.nil?

end
begin
  file.open
File.open(Rails.root.join('public','photos', self.id.to_s+'.img'), 'wb') do |f|
  f.write(file.read)
end
file.close
rescue
ensure
  file.close unless file.nil?

end

write_attribute(:image,file.original_filename)

    end
end

  def self.findwithparams(form_sexe, form_couple, form_departement, form_pays, form_ville, form_agemin, form_agemax, form_aime, form_avatar_perso, form_bahut, form_order, results,nb2)
  agemax=Date.today.year-form_agemax.to_i
  agemin=Date.today.year-form_agemin.to_i
  case form_order
  when "alpha"
    myorder={fullname: :asc}
  when "ville"
    myorder={cityname: :asc}
  when "age"
    myorder={agemember: :asc}
  when "sexe"
    myorder={sex: :asc}
  when "id"
    myorder={created_at: :desc}
  else
    myorder={lastpageseen: :desc}

  end
    left_joins(:city, :country,:departement,:vuearticles).group("members.id").select("members.*,max(vuearticles.created_at) as lastpageseen,(cast(strftime('%Y','now') as int) - cast(strftime('%Y',dateofbirth) as int)) as currentagemember,cast(strftime('%Y',dateofbirth) as int) as agemember, (members.firstname || ' ' || members.lastname) as fullname,cities.name as cityname, countries.name as countryname, departements.name as departementname").having(["sex like ? or couple like ? or lower(departementname) like ? or lower(countryname) like ? or lower(cityname) like ? or (agemember <= ? or  agemember >= ?)"]+[form_sexe,form_couple,form_departement,form_pays,form_ville].map{|h|"%#{h}%"}+[agemin,agemax]).order(myorder)
  rescue => e
    p "ùy error"
  end
    def self.leplusmessagesforum
    all.joins(:forums, :forumcommentaires).select('members.*,members.id as memberid,  forums.id as forumid, forumcommentaires.id as forumcomid, count(forums.id) as countforumsid, count(forumcommentaires.id) as countforumcomid, (count(distinct forums.id)+count(distinct forumcommentaires.id)) as countmessage').group("memberid").order("countmessage" => :desc).limit(3)
  end
  def self.lepluslu
    all.joins(:vuearticles).select('members.*, members.id as memberid, vuearticles.id as vueart, count(distinct vuearticles.id) as countvue').group("memberid").order("countvue" => :desc).limit(3)
  end
  def self.leplusdefliz
    []
  end
  def self.searchmembres(q)
    qq = "%#{q.downcase.gsub(' ','%')}%"

    joins(:city, :country).having(["lower(cityname) like ? or lower(countryname) like ? or lower(uname) like ? or lower(fullname) like ?",qq,qq,qq,qq]).group('mid').select("members.*, members.id as mid, cities.name as cityname, countries.name as countryname, members.username as uname, (members.firstname|| ' '||members.lastname) as fullname")
  end
  def self.leplusarticles
    all.joins(:articles).select('members.*,members.id as memberid,  articles.id as artid, count(distinct articles.id) as countarticles').group("memberid").order("countarticles" => :desc).limit(3)
  end

  def fullname
    firstname+" "+lastname
  end
  def age
      now = Time.now.utc.to_date
  a=now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
a.to_s+" ans"
  end
  def agevalue
      now = Time.now.utc.to_date
  a=now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
a.to_s
  end
  def self.findby(j)
    k=j.values
    u=Member.find_by(email: k[0]) || Member.find_by(username: k[0])
    p u
    if u && u.valid_password?(k[1])
      u
    else
      nil
    end
  end
  def self.nbfemmes
    Member.where(sex:"f").count
  end
  def self.nbhommes
    Member.where(sex:"m").count
  end

  def mycity
    if form_naissance_annee
    maville=City.find_or_create_by(name: form_ville)
    monpays= Country.find_or_create_by(name: form_pays)
    self.city = maville
    self.country = monpays
    self.username=form_login
    self.firstname=form_prenom
    self.lastname=form_nom
    if form_mdp != ''
    self.password=form_mdp
    end
    self.email=form_email
    self.sex=form_sexe
    self.dateofbirth = Date.new(form_naissance_annee.to_i, form_naissance_mois.to_i,form_naissance_jour.to_i)
    end
    if photosmembre && photosmembre.length > 0
      photosmembre.each do |photo|
        photos.new(image: photo, title: self.username+" ("+self.fullname+")")
      end
    end
    if contentdedicace
      dedicaces.new(sender_id: currentmemberid, content: contentdedicace)
    end
    if contentmessage
      messages.new(sender_id: currentmemberid, content: contentmessage)
    end
  end
end

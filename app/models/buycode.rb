class Buycode < ApplicationRecord
  attr_accessor :proceed,:card_token,:memberid, :rememberEmail,:browser_info, :ids, :idd, :lang, :numberOfCodes, :netsurferEmail, :card, :rememberCreditCard,:cvc1, :ccexp1, :ccname1, :cardnumber1
  validates_presence_of :cvc
  validates_presence_of :ccname
  has_many :accesscodes
  has_many :ultramembers, through: :accesscodes, source: :member
  validates_presence_of :cardnumber
  validates_presence_of :numberOfCodes
  validates_presence_of :email
  before_validation :validexpiration
   validates_each :cardnumber do |record, attr, value|
    record.errors.add(attr, 'doit commencer par 3, 4, 5 ou 6') if !value.to_s[0].in?([?3, ?4, ?5])
    record.errors.add(attr, 'le code est de la mauvaise longueur') if !value.to_s.length.in?([13, 15 ,16])
    record.errors.add(attr, "le code de la visa card n'est pas valide") if !value.to_s.length.in?([13, 16]) && value.to_s[0].in?([?4])
    record.errors.add(attr, "le code de la master card n'est pas valide") if !value.to_s.length.in?([16]) && value.to_s[0].in?([?5])
    record.errors.add(attr, "le code de la American Express card n'est pas valide") if !value.to_s.length.in?([15]) && value.to_s[0..1].in?(["34", "37"])
  end
  before_validation :mycodes, on: [:create]
  def validexpiration
    madate=ccexp1.to_s.strip.squish
      d=DateTime.strptime(madate, '%m/%y') rescue nil
      if madate.length == 5 && d 
        self.ccexp=d.to_date
      else
      errors.add(:ccexp, "doit être bien rempli (mm/aa)")

      end

      # Raise error for expired card

  end
  def mycodes
    if proceed == "1" && card == "new-card"
      self.cvc=cvc1
      self.ccname=ccname1
      self.ccexp=ccexp1
      self.cardnumber=cardnumber1
      self.price=numberOfCodes.to_f * 2.0
      self.member_id=memberid
      self.email=netsurferEmail
      self.rememberemail=rememberEmail
      numberOfCodes.to_i.times do
        accesscodes.new(member_id: memberid)
      end
      
    end
  end
  def myerrors
    myfield={"cvc" => "cvc",
      "ccname" => "cardHolder",
      "ccexp" => "expiryDate",
      "email" => "netsurferEmail",
      "cardnumber" => "cardNumber"
    }
    k=self.errors.messages.to_a.map{|a,b|{"field"=>(myfield[a.to_s] || a).to_s,"error"=>b.join(', ')}}
    p k
    k
  end
end

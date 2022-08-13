class Accesscode < ApplicationRecord
  belongs_to :member
  belongs_to :buycode
  validates_uniqueness_of :code
  before_validation :createcode, on: [:create]
  def createcode
    range = [*'0'..'9', *'a'..'z', *'A'..'Z']


    self.code = Array.new(8){range.sample}.join
  end

end

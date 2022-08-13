class Privateforum < ApplicationRecord
  belongs_to :member
  belongs_to :updatemember, optional: true, class_name: "Member"
  has_many :privatemessages
  accepts_nested_attributes_for :privatemessages
end

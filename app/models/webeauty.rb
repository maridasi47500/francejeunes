class Webeauty < ApplicationRecord
  belongs_to :beautymember, class_name: "Member"
  belongs_to :member
  validates_uniqueness_of :beautymember_id, scope: [:member_id, :note]
end

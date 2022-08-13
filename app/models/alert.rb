class Alert < ApplicationRecord
  belongs_to :member
  validates_uniqueness_of :member_id
end

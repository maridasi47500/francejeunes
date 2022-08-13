class Vuefiche < ApplicationRecord
  belongs_to :vuemember, class_name: "Member"
  belongs_to :member, optional: true
end

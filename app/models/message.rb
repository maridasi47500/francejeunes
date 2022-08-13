class Message < ApplicationRecord
  belongs_to :member
  belongs_to :sender, class_name: "Member"
end
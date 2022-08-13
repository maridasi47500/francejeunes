class Privatemessage < ApplicationRecord
  belongs_to :privateforum
  belongs_to :member
end

class Vuesong < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :song
end

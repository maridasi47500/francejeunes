class Vueforum < ApplicationRecord
  belongs_to :forum
  belongs_to :member, optional: true
  
end

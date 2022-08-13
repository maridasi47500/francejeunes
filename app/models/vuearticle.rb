class Vuearticle < ApplicationRecord
  belongs_to :article
  belongs_to :member, optional: true
end

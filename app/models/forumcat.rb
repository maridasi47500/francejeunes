class Forumcat < ApplicationRecord
  has_many :forumsubcats
  has_many :forums, through: :forumsubcats
  has_many :forumcommentaires, through: :forumsubcats
  def forummessages
    forumsubcats.distinct.left_joins(:forums, :forumcommentaires).select('forumsubcats.*,forumsubcats.id as forumcatid, forumsubcats.name, forums.id as forumid, forumcommentaires.id as forumcommentaireid,forums.created_at as forumcreatedat, forumcommentaires.created_at as forumcommentairecreatedat, (count(distinct forums.id)+count(distinct forumcommentaires.id)) as nbmessage, max((SELECT MAX(forums.created_at) as maxforumcreated FROM forums WHERE forums.forumsubcat_id = forumsubcats.id), (SELECT MAX(forumcommentaires.created_at) as maxforumcomcreated WHERE forumcommentaires.forum_id = forums.id)) as derniermessage, (SELECT MAX(forums.created_at) as maxforumcomcreated2 WHERE forumsubcats.id = forums.forumsubcat_id) as dernierforum').group('forumcatid')
  end
end

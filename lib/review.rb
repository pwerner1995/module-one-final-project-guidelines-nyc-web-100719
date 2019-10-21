class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :album
end


#minimum functionaltiy 
# - user can write a review for specified album
# - show reviews for specifed artist or album
# - show reviews for specified user
# - show albums for speicfied release date
# - most popular albums = most reviewed (num of reviews per album and per artist)
# - highest/lowest rated
# - highest/lowest rated artists
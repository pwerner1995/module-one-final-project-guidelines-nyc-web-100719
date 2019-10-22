class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :album

    def self.find_review_by_artist(artist_name)

        artist = Artist.find_by(name: artist_name)
        albums = Album.all.select do |album|
            album.artist_id == artist.id
        end
        albums.map do |album|
            album.reviews
        end
    end


end


#minimum functionaltiy 
# - user can write a review for specified album
# - show reviews for specifed artist or album
# - show reviews for specified user
# - show albums for speicfied release date
# - most popular albums = most reviewed (num of reviews per album and per artist)
# - highest/lowest rated
# - highest/lowest rated artists
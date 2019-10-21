class User < ActiveRecord::Base
    has_many :reviews
    has_many :albums, through: :reviews

    def date_format
        year = Time.now.year
        month = Time.now.month
        day = Time.now.day
        return "#{month}-#{day}, #{year}"
    end

    def write_review(album_id, review_content)
        date = date_format
        Review.create(date, album_id, self, review_content)
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

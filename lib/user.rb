
class User < ActiveRecord::Base
    has_many :reviews
    has_many :albums, through: :reviews

    def date_format
        year = Time.now.year
        month = Time.now.month
        day = Time.now.day
        return "#{month}-#{day}, #{year}"
    end

    def write_review(album_id:, review_content:, rating: 0.0)
        if rating < 0
            Review.create(album_id: album_id, user_id: self.id, review_content: review_content, rating: 0.0)
        elsif rating > 10
            Review.create(album_id: album_id, user_id: self.id, review_content: review_content, rating: 10.0)
        else
            Review.create(album_id: album_id, user_id: self.id, review_content: review_content, rating: rating)
        end
        self
    end

    def show_reviews
        self.reviews
    end

end

#minimum functionaltiy 
# - user can write a review for specified album X
# - show reviews for specifed artist or album(X album)
# - show reviews for specified user X 
# - show albums for speicfied release date X
# - most popular albums = most reviewed (num of reviews per album and per artist) X
# - highest X /lowest rated X
# - highest/lowest rated artists

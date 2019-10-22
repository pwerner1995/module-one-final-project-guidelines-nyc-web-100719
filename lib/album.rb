class Album < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def average_rating
        arr = self.reviews.map do |review|
            review.rating
        end
        total=0
        arr.each do |rating|
            total+=rating
        end
        return total/arr.count
    end

    def album_reviews
        self.reviews
    end

    def self.find_by_release_year(year:)
        self.all.select do |album|
            album.release_year==year
        end
    end

    def self.most_popular
        Album.all.max_by do |album|
            album.reviews.count
        end
    end

    

    def self.highest_rated
        max_review = Album.all.max_by do |album|
            album.average_rating
        end
        album = Album.find_by(id: max_review.id)
        return "#{album.title} - #{max_review.average_rating}"
    end

    def self.lowest_rated
        min_review = Album.all.min_by do |album|
            album.average_rating
        end
        album = Album.find_by(id: min_review.id)
        return "#{album.title} - #{min_review.average_rating}"
    end
end

#minimum functionaltiy 
# - user can write a review for specified album X
# - show reviews for specifed artist or album X(album)
# - show reviews for specified user
# - show albums for speicfied release date X
# - most popular albums = most reviewed (num of reviews per album and per artist) X
# - highest/lowest ratedX
# - highest/lowest rated artists
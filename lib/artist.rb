class Artist < ActiveRecord::Base
    has_many :albums

    def all_albums
        self.albums
    end

    def num_reviews
        count = 0
        all_albums.each do |album|
            count += album.reviews.count
        end
        return count
    end

    def average_rating
        total = 0
        all_albums.each do |album|
            total += album.average_rating
        end
        return total/all_albums.count
    end

    def self.highest_rated_artist
        Artist.all.max_by do |artist|
            artist.average_rating
        end     
    end

    def self.lowest_rated_artist
        Artist.all.min_by do |artist|
            artist.average_rating
        end
    end

end

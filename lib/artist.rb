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
        count = all_albums.count
        all_albums.each do |album|
            if album.average_rating == "No reviews"
                count -= 1
            else
                total += album.average_rating
            end
        end
        if count == 0
            return "No reviews"
        else 
            return (total/count).round(2)
        end
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

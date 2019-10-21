class AddRatingToReviews < ActiveRecord::Migration[5.1]

    def change
        add_column :reviews, :rating, :float
    end

end
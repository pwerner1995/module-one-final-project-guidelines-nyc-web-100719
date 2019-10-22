class CreateReviews < ActiveRecord::Migration[5.1]
    def change
        create_table :reviews do |t|
            t.integer :album_id
            t.integer :user_id
            t.float :rating
            t.text :review_content

            t.timestamps
        end
    end
end

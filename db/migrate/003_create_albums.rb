class CreateAlbums < ActiveRecord::Migration[5.1]
    def change
        create_table :albums do |t|
            t.integer :artist_id
            t.string :title
            t.integer :release_year
            t.timestamps
        end
    end
end

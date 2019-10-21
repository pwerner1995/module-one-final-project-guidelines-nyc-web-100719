class CreateUsers ActiveReader::Migration[5.1]
    def change
        create_table :users do |t|
            t.string :username
            t.string :password
            t.string :first_name
            t.string :last_name
        end
    end
end
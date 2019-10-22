require 'tty-prompt'
require 'pry'
class MyReview 
    def run  
        username = prompt_user
        menubar = menu
        choice(menubar, username)
    end

    def prompt
        TTY::Prompt.new
    end

    def get_user_info
        username = prompt.ask('Enter your username:')
        password = prompt.mask('Enter password:')
        first_name = prompt.ask('Enter your first name')
        last_name = prompt.ask('Enter your last name')
        User.create(username: username, password: password, first_name: first_name, last_name: last_name)
    end

    def prompt_user
        puts "Welcome to Bete's by Flatiron!!"
        username = prompt.ask('Enter your username:', convert: :string)
        all_usernames = User.all.map do |user|
            user.username
        end
        if !all_usernames.include?(username)
            puts "Username does not exist"
            yesno = prompt.yes?('Would you like to create a new account?')
            if yesno
                get_user_info
            else
                puts "Goodbye!"
            end
        else
            puts "Welcome back!"
            prompt_password(username)
        end
    end

    def prompt_password(username)
        password = prompt.mask('Enter password:')
        user = User.find_by(username: username)
        if user.password == password
            puts "Welcome!"
        else 
            puts "Wrong password, try again later :("
        end
        username
    end

    def menu
        menubar = prompt.select("Select your album review option:") do |menu|
            menu.choice 'Write a review'
            menu.choice 'View your past reviews'
            menu.choice 'View an album' #print out that album's reviews and highest/lowest avg ratings
            menu.choice 'View an artist' #print out that artist's reviews and highest/lowest avg ratings
        end   

    end

    def choice(menubar, username)
        if menubar == "Write a review"
            choice_write_review(username)
        elsif menubar == "View your past reviews"
            choice_view_reviews
        elsif menubar == "View an album"
            choice_album_info
        elsif menubar == "View an artist"
            choice_artist_info
        else
            puts "Goodbye"
        end
    end

    def choice_write_review(username)
        user = User.find_by(username: username)
        artist = prompt.ask('Enter artist name:')
        title = prompt.ask('Enter the album title to review:')
        release_year = prompt.ask('Enter the album release year')
        review_content = prompt.ask('Enter your review:')
        rating = prompt.ask('Enter your rating:').to_f
        album_titles = Album.all.select do |album|
            album.title == title
        end
        artists = Artist.all.select do |artist|
            artist.name == artist
        end
        if album_titles.empty? && artists.empty?
            new_artist = Artist.create(name: artist)
            new_album = Album.create(artist_id: new_artist.id, title: title, release_year: release_year)
            review = user.write_review(album_id: new_album.id, review_content: review_content, rating: rating)
            pp review
        else
            album_id = Album.find_by(title: title).id
            user = User.find_by(username: username)
            review = user.write_review(album_id: album_id, review_content: review_content, rating: rating)
            pp review
        end
    end


end

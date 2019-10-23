require 'tty-prompt'
require 'pry'
class MyReview 
    def run  
        username = prompt_user
        if username
            menubar = menu(username)
        else
            "Goodbye!".light_red
        end
    end

    def prompt
        TTY::Prompt.new
    end

    def get_user_info
        username = prompt.ask('Enter your username:'.light_red)
        password = prompt.mask('Enter password:'.light_red)
        first_name = prompt.ask('Enter your first name'.light_red)
        last_name = prompt.ask('Enter your last name'.light_red)
        User.create(username: username, password: password, first_name: first_name, last_name: last_name)
    end

    def prompt_user
        puts "Welcome to Bete's by Flatiron!".light_red
        username = prompt.ask('Enter your username:'.light_red, convert: :string)
        all_usernames = User.all.map do |user|
            user.username
        end
        if !all_usernames.include?(username)
            puts "Username does not exist".light_red
            yesno = prompt.yes?('Would you like to create a new account?'.light_red)
            if yesno
                user = get_user_info
                username = user.username
            else
                puts "Goodbye!".light_red
            end
        else
            puts "Welcome back!".light_red
            prompt_password(username)
        end
    end

    def prompt_password(username)
        password = prompt.mask('Enter password:'.light_red)
        user = User.find_by(username: username)
        if user.password == password
            puts "Welcome!".light_red
            username
        else 
            puts "Wrong password, try again later :(".light_red
            prompt_password(username)
        end
    end

    def menu(username)
        menubar = prompt.select("Select your album review option:".light_red) do |menu|
            menu.choice 'Write a review'.light_red
            menu.choice 'View your past reviews'.light_red
            menu.choice 'View an album'.light_red 
            menu.choice 'View an artist'.light_red 
        end
        choice(menubar, username)
    end

    def choice(menubar, username)
        if menubar == "Write a review".light_red
            choice_write_review(username)
        elsif menubar == "View your past reviews".light_red
            choice_view_reviews(username)
        elsif menubar == "View an album".light_red
            choice_album_info(username)
        elsif menubar == "View an artist".light_red
            choice_artist_info(username)
        else
            puts "Goodbye".light_red
        end
    end

    def choice_write_review(username)
        user = User.find_by(username: username)
        artist = prompt.ask('Enter artist name:'.light_red).upcase
        title = prompt.ask('Enter the album title to review:'.light_red).upcase
        release_year = prompt.ask('Enter the album release year:'.light_red)
        review_content = prompt.ask('Enter your review:'.light_red)
        rating = prompt.ask('Enter your rating:'.light_red).to_f
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
        new_prompt = prompt.yes?('Would you like to do something else'.light_red)
        if new_prompt
            menu(username)
        else
            puts "Goodbye!".light_red
        end
    end

    def choice_view_reviews(username)
        user = User.find_by(username: username)
        pp user.reviews
        new_prompt = prompt.yes?('Would you like to do something else'.light_red)
        if new_prompt
            menu(username)
            binding.pry
        else
            puts "Goodbye!".light_red
        end
    end

    def choice_album_info(username)
        album = prompt.ask('What album would you like to view?'.light_red).upcase
        selected_album = Album.find_by(title: album)
        if selected_album
            artist = Artist.find_by(id: selected_album.artist_id)
            puts "Artist: #{artist.name}".light_red
            print_album_info(selected_album)
            new_prompt = prompt.yes?('Would you like to do something else'.light_red)
            if new_prompt
                menu(username)
            else
                puts "Goodbye!".light_red
            end
        else
            puts "This album does not exist in the database".light_red
            yesno = prompt.yes?('Would you like to try again'.light_red)
            if yesno
                choice_album_info(username)
            else
                new_prompt = prompt.yes?('Would you like to do something else'.light_red)
                    if new_prompt
                        menu(username)
                    else
                        puts "Goodbye!".light_red
                    end
            end
        end
    end

    def choice_artist_info(username)
        artist = prompt.ask('What artist would you like to view?'.light_red).upcase
        selected_artist = Artist.find_by(name: artist)
        puts "Artist name: #{selected_artist.name}".light_red
        puts "Total average rating: #{selected_artist.average_rating}".light_red
        puts '*'.light_red * 26
        selected_artist.albums.each do |album|
            print_album_info(album)
        end
        new_prompt = prompt.yes?('Would you like to do something else'.light_red)
        if new_prompt
            menu(username)
        else
            puts "Goodbye!".light_red
        end
    end

    private

    def print_album_info(album)
        puts "Title: #{album.title}".light_red
        puts "Average rating: #{album.average_rating}".light_red
    end


end

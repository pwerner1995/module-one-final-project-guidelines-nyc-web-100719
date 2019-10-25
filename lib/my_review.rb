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
        puts ""
        username = prompt.ask('Enter your username:'.light_red)
        password = prompt.mask('Enter password:'.light_red)
        first_name = prompt.ask('Enter your first name'.light_red)
        last_name = prompt.ask('Enter your last name'.light_red)
        user = User.create(username: username, password: password, first_name: first_name, last_name: last_name)
        puts ""
        puts "Welcome, #{first_name}!"
        return user
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
            prompt_password(username)
        end
    end

    def prompt_password(username)
        password = prompt.mask('Enter password:'.light_red)
        puts ""
        if find(username).password == password
            puts "Welcome back, #{find(username).first_name}!".light_red
            puts ""
            username
        else 
            puts "Wrong password, try again later :(".light_red
            puts ""
            prompt_password(username)
        end
    end


    def menu(username)
        if find(username).reviews.empty?
            menubar = prompt.select("Select your album review option:".light_red) do |menu|
                menu.choice 'Write a review'.light_red
                menu.choice 'View your past reviews'.light_red #have to account for null response in albums
                menu.choice 'View an album'.light_red 
                menu.choice 'View an artist'.light_red
                menu.choice 'Exit'.light_red
            end
            puts ""
            choice(menubar, username)
        else
            menubar = prompt.select("Select your album review option:".light_red) do |menu|
                menu.choice 'Write a review'.light_red
                menu.choice 'View your past reviews'.light_red #have to account for null response in albums
                menu.choice 'Delete a past review'.light_red #need to add check for new user without any past reviews X
                menu.choice 'View an album'.light_red 
                menu.choice 'View an artist'.light_red
                menu.choice 'Bete it'.light_red
            end
            puts ""
            choice(menubar, username)
        end
    end

    def choice(menubar, username)
        if menubar == "Write a review".light_red
            choice_write_review(username)
        elsif menubar == "View your past reviews".light_red
            choice_view_reviews(username)
        elsif menubar == "Delete a past review".light_red
            choice_delete_review(username)
        elsif menubar == "View an album".light_red
            choice_album_info(username)
        elsif menubar == "View an artist".light_red
            choice_artist_info(username)
        elsif menubar == "Bete it".light_red
            puts "Goodbye!".light_red
        end
    end

    def choice_write_review(username)
        artist_to_review = prompt.ask('Enter artist name (press ENTER to view list of previously review artists):'.light_red)
        if artist_to_review == nil
            artist_names = Artist.all.map do |artist| 
                artist.name
            end
            artist_to_review = prompt.select('What artist would you like to view?'.light_red, artist_names)
        end
        artist_to_review=artist_to_review.upcase.strip
        title_to_review = prompt.ask('Enter the album title to review:'.light_red)
        if title_to_review == nil
            titles = Album.all.select do |album| 
                album.artist_id == Artist.find_by(name: artist_to_review).id
            end
            titles= titles.map do |album|
                album.title
            end
            title_to_review = prompt.select('Which existing album would you like to view?'.light_red, titles)
        end
        title_to_review= title_to_review.upcase.strip
        binding.pry
        release_year = prompt.ask('Enter the album release year:'.light_red).to_i
        if release_year > 2100 || release_year < 1800
            release_year = 1995
        end
        review_content = prompt.ask('Enter your review:'.light_red)
        rating = prompt.ask('Enter your rating (out of 10):'.light_red).to_f
        album_titles = Album.all.map do |album|
            album.title
        end
        artists = Artist.all.map do |artist|
            artist.name
        end
        if !album_titles.include?(title_to_review) && !artists.include?(artist_to_review) #new album title and new artist name
            artist = Artist.create(name: artist_to_review)
            album = Album.create(artist_id: artist.id, title: title_to_review, release_year: release_year)
            review = find(username).write_review(album_id: album.id, review_content: review_content, rating: rating)
            display_new_review(artist, album, review)
        elsif !album_titles.include?(title_to_review) #new album title and existing artist name
            artist = Artist.find_by(name: artist_to_review)
            album = Album.create(artist_id: artist.id, title: title_to_review, release_year: release_year)
            review = find(username).write_review(album_id: album.id, review_content: review_content, rating: rating)
            display_new_review(artist, album, review)
        else #existing album title existing artist name
            album = Album.find_by(title: title_to_review)
            artist = Artist.find_by(id: album.artist_id)
            if album.artist_id != artist.id
                album = Album.create(artist_id: artist.id, title: title_to_review, release_year: release_year)
            end
            album_id = album.id
            review = find(username).write_review(album_id: album_id, review_content: review_content, rating: rating)
            display_new_review(artist, album, review)
        end
        new_prompt(username)
    end


    def choice_view_reviews(username)
        past_reviews=find(username).reviews.each do |review|
            album = Album.find_by(id: review.album_id)
            artist = Artist.find_by(id: album.artist_id)
            display_reviews(album, artist, review, username)
        end
        if past_reviews.empty?
            puts "You haven't reviewed any albums yet! Go review something...".light_red
        end
        new_prompt(username)
    end


    def choice_delete_review(username)
        my_reviews = find(username).reviews.each do |review|
            album = Album.find_by(id: review.album_id)
            artist = Artist.find_by(id: album.artist_id)
            display_reviews(album, artist, review, username)
        end
        album_titles = my_reviews.map do |review| 
            album = review.album
            album.title
        end
        album_choice = prompt.select('Select a past review:'.light_red, album_titles)
        album = Album.find_by(title: album_choice)
        review = Review.find_by(album_id: album.id)
        review.destroy
        puts "This review has been removed"
        new_prompt(username)
    end

    def choice_album_info(username)
        album_titles = Album.all.map do |album| 
            album.title
        end
        album = prompt.select('What album would you like to view?'.light_red, album_titles)
        selected_album = Album.find_by(title: album)
        if selected_album
            artist = Artist.find_by(id: selected_album.artist_id)
            puts ""
            puts "Artist: #{artist.name}".light_red
            print_album_info(selected_album, username)
            new_prompt(username)
        else
            puts "This album does not exist in the database".light_red
            puts ""
            yesno = prompt.yes?('Would you like to try again'.light_red)
            if yesno
                choice_album_info(username)
            else
                new_prompt(username)
            end
        end
    end

    def choice_artist_info(username)
        artist_names = Artist.all.map do |artist| 
            artist.name
        end
        artist = prompt.select('What artist would you like to view?'.light_red, artist_names)
        selected_artist = Artist.find_by(name: artist)
        puts ""
        puts "Artist name: #{selected_artist.name}".light_red
        puts "Total average rating: #{selected_artist.average_rating}".light_red
        puts ""
        puts "DISCOGRAPHY".light_red
        puts ""
        selected_artist.albums.each do |album|
            print_album_info(album, username)
            puts '*' * 26
        end
        new_prompt(username)
    end

    #helpers

    def print_album_info(album, username)
        puts "Title: #{album.title}".light_red
        puts "Average rating: #{album.average_rating}".light_red
        puts "Your rating: #{album.user_rating(username)}".light_red
    end

    def new_prompt(username)
        puts ""
        new_prompt = prompt.yes?('Would you like to do something else'.light_red)
        if new_prompt
            menu(username)
        else
            puts "Goodbye!".light_red
        end
    end

    def display_new_review(artist, album, review)
        puts ""
        puts "Artist: #{artist.name}".light_red
        puts "Album: #{album.title}".light_red
        puts "Release Year: #{album.release_year}".light_red
        puts "Review: #{review.review_content}".light_red
        puts "Rating: #{review.rating.to_s}".light_red
        puts ""
    end

    def display_reviews(album, artist, review, username)
        puts "Album: #{album.title}".light_red
        puts "Artist: #{artist.name}".light_red
        puts "Release Year: #{album.release_year}".light_red
        puts "Review: #{review.review_content}".light_red
        puts "Average Rating: #{album.average_rating}".light_red
        puts "Your rating: #{album.user_rating(username)}".light_red
        puts "*" * 26
        puts ""
    end

    def find(username)
        User.find_by(username: username)
    end


end

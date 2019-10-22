require 'tty-prompt'
require 'pry'
class MyReview 
    def run  
        user_name=prompt_user
        password=prompt_password
        binding.pry
    end

    def prompt
        TTY::Prompt.new
    end
    def prompt_user
        puts "Welcome to Bete's by Flatiron!!"
        prompt.ask('Enter your username:')
        gets.chomp!
    end
    def prompt_password
        prompt.mask('Enter password:')
        gets.chomp!
    end
end

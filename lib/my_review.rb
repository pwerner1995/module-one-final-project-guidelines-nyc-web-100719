require 'tty-prompt'
require 'pry'
class MyReview 
    def run  
        user_name=prompt_user
        password=prompt_password
        create_user(user_name,password)
        binding.pry
    end

    def prompt
        TTY::Prompt.new
    end
    def create_user(user_name, password)
        
    end
    def prompt_user
        puts "Welcome to Bete's by Flatiron!!"
        prompt.ask('Enter your username:')

    end
    def prompt_password
        prompt.mask('Enter password:')
        # gets.chomp!
    end
end

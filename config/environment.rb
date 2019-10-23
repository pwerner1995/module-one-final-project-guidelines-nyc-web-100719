require 'bundler'
Bundler.require

require 'figlet'
require 'colorize'
font = Figlet::Font.new('./font/speed.flf')
figlet = Figlet::Typesetter.new(font)
puts figlet["Bete's by"].light_red
puts figlet["FLATIRON"].light_red



ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'lib'

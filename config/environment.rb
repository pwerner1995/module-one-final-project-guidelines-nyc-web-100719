require 'bundler'
Bundler.require

require 'figlet'
font = Figlet::Font.new('./font/speed.flf')
figlet = Figlet::Typesetter.new(font)
puts figlet["Bete's by"]
puts figlet["FLATIRON"]



ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

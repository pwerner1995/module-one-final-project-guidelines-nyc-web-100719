#seed data

User.create(username: "bmaewood", password: "password", first_name: "Bailey", last_name: "Wood")
User.create(username: "pwerner", password: "password", first_name: "Peter", last_name: "Werner")

Artist.create(name: "Frank Ocean")
Artist.create(name: "Anderson .Paak")
Artist.create(name: "Chance the Rapper")
Artist.create(name: "Bon Iver")


Album.create(artist_id: 1, release_year: 2016, title: "Blonde")
Album.create(artist_id: 2, release_year: 2017, title: "Malibu")
Album.create(artist_id: 3, release_year: 2013, title: "Acid Rap")
Album.create(artist_id: 4, release_year: 2007, title: "For Emma, Forever Ago")
Album.create(artist_id: 3, release_year: 2019, title: "The Big Day")


Review.create(album_id: 1, user_id: 1, review_content: "awesome", rating: 8.3)
Review.create(album_id: 2, user_id: 2, review_content: "slaps", rating: 9.8)
Review.create(album_id: 3, user_id: 2, review_content: "major flames", rating: 8.9)
Review.create(album_id: 4, user_id: 1, review_content: "crine", rating: 7.4)
Review.create(album_id: 4, user_id: 2, review_content: "solid", rating: 7.9)
Review.create(album_id: 5, user_id: 1, review_content: "eh", rating: 4.4)


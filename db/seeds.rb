#seed data

User.create(username: "bmaewood", password: "password", first_name: "Bailey", last_name: "Wood")
User.create(username: "pwerner", password: "password", first_name: "Peter", last_name: "Werner")



Album.create(release_year: 2016, title: "Blonde")
Album.create(release_year: 2017, title: "Malibu")
Album.create(release_year: 2013, title: "Acid Rap")
Album.create(release_year: 2007, title: "For Emma, Forever Ago")

Album.create(release_year: 2019, title: "The Big Day")


Review.create(album_id: 1, user_id: 1, review_content: "awesome")
Review.create(album_id: 2, user_id: 2, review_content: "slaps")
Review.create(album_id: 3, user_id: 2, review_content: "major flames")
Review.create(album_id: 4, user_id: 1, review_content: "crine")

Review.create(album_id: 4, user_id: 2, review_content: "solid")

Review.create(album_id: 5, user_id: 1, review_content: "eh", rating: 4.4)


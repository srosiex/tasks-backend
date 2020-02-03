# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Task.destroy_all

sarah = User.create(name: 'S', username: 'sh11', email: 'sh1@gmail.com', password: 'test')

task1 = Task.create(content: 'Finish labs.', user: sarah)

note1 = Note.create(reflect: "notes for task")
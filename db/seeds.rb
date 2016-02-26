# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Category.create(description: 'Hotels', image: 'hotel.png')
Category.create(description: 'Gas', image: 'fuel.png')
Category.create(description: 'Places', image: 'tool.png')
Category.create(description: 'Bars', image: 'cup.png')
Category.create(description: 'Food', image: 'food.png')
Category.create(description: 'Drink', image: 'drink.png')
Category.create(description: 'High Tech', image: 'computer.png')

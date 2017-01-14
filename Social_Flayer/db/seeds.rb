# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
@user.save

@user2  = User.new(:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'giovanni', :surname => 'baglio', :username=> 'jova')
@user2.save

@user3 = User.new(:email => 'test3@example.com', :password => 'password', :password_confirmation => 'password',:name => 'giacomo', :surname => 'baglio', :username=> 'gionni')
@user3.save

@store = Store.new(:name => 'pizza_bella' , :location => 'Roma,piazza trento', :owner_id=> @user.id)
@store.save
@store_admin= Work.new(:user_id => @user.id, :store_id => @store.id, :accept => true)
@store_admin.save

@store2 = Store.new(:name => 'pulizia per la casa',:location => 'Veroli', :owner_id=> @user.id)
@store2.save
@store_admin2= Work.new(:user_id => @user.id, :store_id => @store2.id, :accept => true)
@store_admin2.save

@store3= Store.new(:name => 'pulizia per la casa',:location => 'Pofi', :owner_id=> @user2.id)
@store3.save
@store_admin3= Work.new(:user_id => @user2.id, :store_id => @store3.id, :accept => true)
@store_admin3.save

@store_admin4= Work.new(:user_id => @user3.id, :store_id => @store3.id, :accept => false)
@store_admin4.save

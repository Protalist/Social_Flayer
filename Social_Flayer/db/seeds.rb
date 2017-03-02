# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@user = User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all',image: "nopropic.jpg")
@user.save

@user2  = User.new(:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'giovanni', :surname => 'baglio', :username=> 'jova')
@user2.save

@user3 = User.new(:email => 'test3@example.com', :password => 'password', :password_confirmation => 'password',:name => 'giacomo', :surname => 'baglio', :username=> 'gionni',:admin => true)
@user3.save

@store = Store.new(:name => 'pizza_bella' , :location => 'Roma,piazza trento', :owner_id=> @user.id,image: "nopropic.jpg")
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

@item=@store.products.build(:name => "pizza al pomodoro", :price => 2, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>34, :type_p => "cibo")
@item.save

@item2=@store.products.build(:name => "pizza con i funghi", :price => 3, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>32, :type_p => "pizza")
@item2.save

@item3=@store.products.build(:name => "pizza rancida", :price => 1, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>6000000, :type_p => "non cibo")
@item3.save

@item4=@store2.products.build(:name => "detersivo", :price => 2, :feature => "bello pulito", :duration_h=>34, :type_p => "detersivi")
@item.save

@item5=@store2.products.build(:name => "lavapiatti", :price => 3, :feature => "bello pulito", :duration_h=>32, :type_p => "detersivi")
@item5.save

@item6=@store2.products.build(:name => "lava ciupoli", :price => 1, :feature =>"bello pulito", :duration_h=>6000000, :type_p => "accessori")
@item6.save

@item7=@store3.products.build(:name => "detersivo al pomodoro", :price => 2, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>34, :type_p => "detersivo e cibo")
@item7.save

@item8=@store3.products.build(:name => "taglia ugnhie", :price => 3, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>32, :type_p => "accessori")
@item8.save

@item9=@store3.products.build(:name => "leva calli di zio mario", :price => 1, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>6000000, :type_p => "accessori")
@item9.save

@comment=Comment.new(:user_id => @user.id, :store_id => @store3.id, :content => "commento 1")
@comment.save

@comment2=Comment.new(:user_id => @user2.id, :store_id => @store.id, :content => "commento 2")
@comment2.save

@comment3=Comment.new(:user_id => @user3.id, :store_id => @store.id, :content => "commento 3")
@comment3.save

@comment4=Comment.new(:user_id => @user3.id, :store_id => @store.id,:comment_id => @comment2.id, :content => "reply 1")
@comment4.save

@comment5=Comment.new(:user_id => @user2.id, :store_id => @store.id,:comment_id => @comment3.id, :content => "reply 2")
@comment5.save

@respond=Respond.new(:store_id => @store.id, :comment_id => @comment2.id, :content => "respond1")
@respond.save

@follow_store=FollowStore.new(:store_id => @store.id, :user_id => @user.id)
@follow_store.save

@follow_store=FollowStore.new(:store_id => @store.id, :user_id => @user.id)
@follow_store.save

@follow_store2=FollowStore.new(:store_id => @store2.id, :user_id => @user2.id)
@follow_store2.save

@follow_store3=FollowStore.new(:store_id => @store3.id, :user_id => @user3.id)
@follow_store3.save

@follow_user=FollowerUser.new(:followed_id => @user.id, :follower_id => @user2.id)
@follow_user.save

@follow_user2=FollowerUser.new(:followed_id => @user2.id, :follower_id => @user3.id)
@follow_user2.save

@follow_user3=FollowerUser.new(:followed_id => @user3.id, :follower_id => @user.id)
@follow_user3.save

@follow_user4=FollowerUser.new(:followed_id => @user.id, :follower_id => @user3.id)
@follow_user4.save


@store.upvote_from @user

@store2.upvote_from @user2

@store3.upvote_from @user3

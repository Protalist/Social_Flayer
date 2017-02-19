require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  before(:each) do
    @user=User.create(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
    @user2=User.create(:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all2')
    @ability=Ability.new(@user)
    
  end

  context "a guest user" do
    it "should be able to manage self" do
      expect(@ability).to be_able_to(:crud, @user)
    end

    it "should not be able to manage others" do
      expect(@ability).to_not be_able_to(:crud, @user2)
    end
    it "funzioniruolo0" do
      @store = Store.create(:name => "Negozio",:location => "dpgland",:owner_id => 3)
      expect(@ability).to be_able_to(:funzioniruolo0, @store)
    end
    describe "can follow users?" do
      it "can follow" do
        @follow=double("follow", exists?: false)
        allow(FollowerUser).to receive(:where).and_return(@follow)
        expect(@ability).to be_able_to(:follow,@user2)
        expect(@ability).to_not be_able_to(:unfollow,@user2)
      end
      it "can't follow" do
        @follow = double("follow",exists?:true)
        allow(FollowerUser).to receive(:where).and_return(@follow)
        expect(@ability).to_not be_able_to(:follow,@user2)
        expect(@ability).to be_able_to(:unfollow,@user2)
      end
    end
    it "mostra prodotti" do
      @store = Store.create(:name => "Negozio",:location => "dpgland",:owner_id => 3)
      allow(@store).to receive(:products).and_return(true)
      #@product = Product.create(:name => "x",:price => 100.0,:duration_h => 20,:type_p => "cosa",:feature => "bellobello",:store_id =>1)
      
      expect(@ability).to be_able_to(:show,Product)
    end
    describe "can follow stores?" do
      it "can follow" do
        @store = Store.create(:name => "Negozio",:location => "dpgland",:owner_id => 3)
        @follow=double("follow", exists?: false)
        allow(FollowStore).to receive(:where).and_return(@follow)
        expect(@ability).to be_able_to(:follow,@store)
        expect(@ability).to_not be_able_to(:unfollow,@store)
      end
      it "can't follow" do
        @store = Store.create(:name => "Negozio",:location => "dpgland",:owner_id => 3)
        @follow = double("follow",exists?:true)
        allow(FollowStore).to receive(:where).and_return(@follow)
        expect(@ability).to_not be_able_to(:follow,@store)
        expect(@ability).to be_able_to(:unfollow,@store)
      end
    end
    describe "commentiamo?" do
      it "ok commento" do
        @work = double("work",exists?:false)
        @commento = Comment.create(:user_id => 1,:store_id=>1,:content =>"bello",:comment_id=>1)
        allow(Work).to receive(:where).and_return(@work)
        expect(@ability).to be_able_to(:new,@commento)
        expect(@ability).to be_able_to(:create,@commento)
      end
      it "ok rispondo" do
        @work = double("work",exists?:false)
        @commento = Comment.create(:user_id => 1,:store_id=>1,:content =>"bello",:comment_id=>1)
        allow(Work).to receive(:where).and_return(@work)
        expect(@ability).to be_able_to(:reply,@commento)
      end
      it "funzioni con stesso user id" do
        @commento = Comment.create(:user_id => @user.id,:store_id=>1,:content =>"bello",:comment_id=>1)
        expect(@ability).to be_able_to(:funzionistessouserid,@commento)
        @commento2 = Comment.create(:user_id => @user2.id,:store_id=>1,:content =>"bello",:comment_id=>1)
        expect(@ability).to_not be_able_to(:funzionistessouserid,@commento2)
      end  
      it "mostra risposte" do

        expect(@ability).to be_able_to(:indexReply,Comment)
      end
    end
  end
end
    


    
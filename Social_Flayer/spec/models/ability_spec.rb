require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  before(:each) do
    @user=User.create(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
    @user2=User.create(:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all2')
    @ability=Ability.new(@user)

  end
  it "admin" do
    @admin = @user=User.create(:email => 'test3@example.com', :password => 'password', :password_confirmation => 'password',:name => 'do', :surname => 'do', :username=> 'admin',:admin =>true)
    @ability1=Ability.new(@admin)
    expect(@ability1).to be_able_to(:manage,:all)
    expect(@ability).to_not be_able_to(:manage,:all)
  end
  context "a  user client" do
    it "should be able to manage self" do
      expect(@ability).to be_able_to(:manageuser, @user)
    end

    it "should not be able to manage others" do
      expect(@ability).to_not be_able_to(:manageuser, @user2)
    end

    it "can report a user" do
      @report=double("follow", exists?: false)
      allow(Report).to receive(:where).and_return(@report)
      expect(@ability).to be_able_to(:report,@user2)
    end

    it "can't report a user" do
      @report=double("follow", exists?: true)
      allow(Report).to receive(:where).and_return(@report)
      expect(@ability).to_not be_able_to(:report,@user2)
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

    describe "can follow product?" do
      it "can follow" do
        @store = Store.create(:name => "Negozio",:location => "dpgland",:owner_id => 3)
        allow(@store).to receive(:products).and_return(true)
        @product=Product.create(:name => "prova", :store_id => 1 ,:id => 1, :price => 1, :type_p => 1, :duration_h => 1)
        @follow=double("follow", exists?: false)
        allow(FollowProduct).to receive(:where).and_return(@follow)
        expect(@ability).to be_able_to(:follow,@product)
        expect(@ability).to_not be_able_to(:unfollow,@product)
      end
      it "can't follow" do
        @store = Store.create(:name => "Negozio",:location => "dpgland",:owner_id => 3)
        allow(@store).to receive(:products).and_return(true)
        @product=Product.create(:name => "prova", :store_id => 1 ,:id => 1, :price => 1, :type_p => 1, :duration_h => 1)
        @follow = double("follow",exists?:true)
        allow(FollowProduct).to receive(:where).and_return(@follow)
        expect(@ability).to_not be_able_to(:follow,@product)
        expect(@ability).to be_able_to(:unfollow,@product)
      end
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

  describe "clienti owner" do
  before(:each) do
    @user.update(roles_mask: 1)
    @ability=Ability.new(@user)
    @store1= Store.create(:name => 'pizza_bella' , :location => 'Roma,piazza trento', :owner_id=> @user.id)
    @store2= Store.create(:name => 'pizza_bella' , :location => 'Roma,piazza trento', :owner_id=> @user2.id)

  end

  describe "user" do
    it "può cambiare ruolo" do
        expect(@ability).to be_able_to(:roles, User)
    end
  end

  describe "store" do

      it "owner_ab" do
        expect(@ability).to be_able_to(:owner_ab,@store1)
      end

      it "can't owner_ab" do
        expect(@ability).to_not be_able_to(:owner_ab,@store2)
      end

      it "show" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:show,@store1)
      end

      it "can't show" do
        allow(Work).to receive(:where).and_return(double("work", exists?: false))
        expect(@ability).to_not be_able_to(:show,@store1)
      end

    end

    describe "products" do
      before(:each) do
        @item=@store1.products.build(:name => "pizza al pomodoro", :price => 2, :feature => "la pizza al pomodoro più buona del mondo", :duration_h=>34, :type_p => "cibo")

      end
      it "crud_prod" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:crud_prod, @item)
      end

      it "new" do
        expect(@ability).to be_able_to(:new, Product)
      end

    end

    describe "responds" do

      it "crud_respond" do
        @respond=Respond.new(:store_id =>1, :comment_id => 3, :content => "respond1")
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:crud_respond, @respond)
      end

    end

  end

  describe "client pro" do
    before(:each) do
      @user.update(roles_mask: 2)
      @ability=Ability.new(@user)
      @store1= Store.create(:name => 'pizza_bella' , :location => 'Roma,piazza trento', :owner_id=> @user.id)
      @product=Product.create(:name => "prova", :store_id => 1 ,:id => 1, :price => 1, :type_p => 1, :duration_h => 1)
      @respond=Respond.new(:store_id =>1, :comment_id => 3, :content => "respond1")
    end

    describe "store" do
      it "show" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:show, @store1)
      end

      it "leave_store" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:leave_store, @store1)
      end
    end

    describe "products" do
      it  "show" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:show, @product)
      end

      it "new" do
        expect(@ability).to be_able_to(:new, @product)
      end

      it "create" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:create, @product)
      end

      it "edit" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:edit, @product)
      end

      it "update" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:update, @product)
      end

      it "destroy" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:destroy, @product)
      end

    end

    describe "respond" do
      it "new" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:new, @respond)
      end

      it "create" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:create, @respond)
      end

      it "edit" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:edit, @respond)
      end

      it "update" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:update, @respond)
      end

      it "destroy" do
        allow(Work).to receive(:where).and_return(double("work", exists?: true))
        expect(@ability).to be_able_to(:destroy, @respond)
      end

    end


  end
end

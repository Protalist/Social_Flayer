require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user =User.create(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
    #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in user

    @fake_user=double("user", id: 5, include?: true)
    allow(User).to receive(:ids).and_return(@fake_user)
  end

  describe 'get home' do
    it "return home" do
      get :home
      expect(response).to render_template(:home)
    end
  end

  describe "get index" do
    it "route" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "get show" do
      it "route" do
        get :show, params:{id: 1}
        expect(response).to render_template(:show)
      end
  end


  describe "change" do
    before(:each) do
      @fake_store=double("store",owner_id: 2)
      @fake_work=double("works",exists?: true)
      allow(Store).to receive(:find).and_return(@fake_store)
    end

      it "cambia ruolo owner" do
        allow(@fake_store).to receive(:owner_id).and_return(1)
        post :change, params:{store_id: 2}
        expect(response).to redirect_to(store_path(2))
      end

      it "cambia ruolo admin store" do
        allow(Work).to receive(:where).and_return(@fake_work)
        post :change, params:{store_id: 2}
        expect(response).to redirect_to(store_path(2))
      end

      it "non posso gestire questo negozio" do
        allow(@fake_work).to receive(:exists?).and_return(false)
        allow(Work).to receive(:where).and_return(@fake_work)
        post :change, params:{store_id: 2}
        expect(response).to redirect_to(root_path)
      end
  end

  describe "back" do
    it "torna in home" do
      expect(subject.current_user).to receive(:update).with({roles_mask: 0})
      get :back
      expect(response).to redirect_to(root_path)
    end
  end

  describe "follow" do
    before(:each) do
      @fake_follow=double("follow", :follower_id= => true, :followed_id= => true, :save => false)
      allow(controller).to receive(:authorize!).and_return("ok")
      allow(User).to receive(:find).and_return(@fake_user)
    end

    describe "chiamata tramite html" do
      it "può essere seguito" do
        post :follow,params:{id: 5}
        expect(response).to redirect_to(user_path(5))
      end

      it "non può essere seguito" do
        post :follow,params:{id: 1}
        expect(response).to redirect_to(user_path(5))
      end
    end

    describe "chiamata tramite ajax" do
      it "può essere seguito" do
        post :follow,params:{id: 5, format: :js}
        expect(response).to render_template("follow")
      end

      it "non può essere seguito" do
        allow(FollowerUser).to receive(:new).and_return(@fake_follow)
        post :follow,params:{id: 1, format: :js}
        expect(response).to render_template("shared/nothing")
      end
    end


  end

  describe "unfollow" do
    before(:each) do
      @follow=double("follow", first: double("foll"))
      allow(FollowerUser).to receive(:where).and_return(@follow)
    end

    describe "chiamata tramite html" do
      it "posso fare l'unfollow" do
        allow(@follow.first).to receive(:destroy).and_return(true)
        post :unfollow, params:{id: 1}
        expect(response).to redirect_to(user_path(1))
      end

      it "non posso fare l'unfollow" do
        allow(@follow).to receive(:first).and_return(nil)
        post :unfollow, params:{id: 1}
        expect(response).to redirect_to(user_path(1))
      end
    end

    describe "chiamata tramite ajax" do
      it "posso fare l'unfollow" do
        allow(@follow.first).to receive(:destroy).and_return(true)
        post :unfollow, params:{id: 1,format: :js}
        expect(response).to render_template(:unfollow)
      end

      it "non posso fare l'unfollow" do
        allow(@follow).to receive(:first).and_return(nil)
        post :unfollow, params:{id: 1, format: :js}
        expect(response).to render_template("shared/nothing")
      end
    end

  end


 #metodo privato
  describe "user" do
    it "il user esiste" do
      #allow(@fake_comment).to receive(:include?).with(1).and_return(true)
      allow(controller).to receive(:params).and_return({id: "2"})
      expect(User).to receive(:find)
      controller.send(:user)
    end

    it "il user non  esiste" do
      allow(@fake_user).to receive(:include?).with(2).and_return(false)
      allow(controller).to receive(:params).and_return({id: "2"})
      expect(controller).to receive(:redirect_to)
      controller.send(:user)
    end
  end
end

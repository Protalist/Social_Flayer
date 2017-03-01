require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  before(:each) do
    #simula l'inserimento del current user e regola il controllo se esiste uno store
    @fake_user_client=double('User', id: 1, roles_mask: 0,ban:0)
    @fake_user_store=double('USer',id: 1, roles_mask: 1,ban: 0)
    @fake_store=double('Stores', stores: [double("store1",id:1),double("store2",id:2)])
    @fake_producs=double('Product', products: [double("prod1"),double("prod2")])
    @fake_comments=double('Comment', comments: [double("comment1"),double("comment2")])
    allow(controller).to receive(:authorize!).and_return(true)
    allow(Store).to receive(:ids).and_return(@fake_store)
    allow(@fake_store).to receive(:include?).with(1).and_return(true)
    allow(Store).to receive(:find).with("1").and_return(@fake_store.stores[0])
  end

  describe  "GET INDEX" do
    before(:each) do
      allow(Store).to receive(:search).and_return(@fake_store.stores)
      @fake_store.stores.each do |s|
        allow(s).to receive(:distance_from).with("roma").and_return(3)
        allow(s).to receive(:get_upvotes).and_return([2,3])
      end
    end

    describe 'ritorna la map' do
      it "senza view" do
        get :index, params:{location: "roma"}
        expect(response).to render_template("index")
      end

      it "con view map" do
        get :index, params:{location: "roma", view: "map"}
        expect(response).to render_template("index")
      end
    end

    it "controllo parametri" do
      get :index, params:{location: "roma"}
      expect(assigns(:stores)).to eq(@fake_store.stores)
    end

    it "ritorna il secondo metodo per visualizzare gli store" do
      get :index, params:{location: "roma", view: "like"}
      expect(response).to render_template("index2")
    end

  end

  describe 'GET SHOW' do
    before(:each) do
      allow(Store).to receive(:find).with("1").and_return(@fake_store.stores[0])
      allow(@fake_store.stores[0]).to receive(:products).and_return(@fake_producs)
      allow(@fake_store.stores[0]).to receive(:comments).and_return(@fake_comments)
      allow(@fake_comments).to receive(:where).with("comment_id IS NULL").and_return(@fake_comments.comments)
    end

    describe "roulo cliente" do
      before(:each) do
        allow(controller).to receive(:current_user).and_return(@fake_user_client)
        allow(controller).to receive(:authorize!).with(:show,@fake_store.stores[0]).and_return('passed')

      end

      it "negozio esiste" do
        get :show, params:{id: "1"}
        expect(response).to render_template(:show)
      end

      it "negozio esiste" do
        allow(@fake_store).to receive(:include?).with(1).and_return(true)
        get :show, params:{id: "1"}
        expect(assigns(:show)).to eq(@fake_store.stores[0])
        expect(assigns(:products)).to eq(@fake_producs)
        expect(assigns(:comments)).to eq(@fake_comments.comments)

      end

      it "negozio non esiste" do
        allow(@fake_store).to receive(:include?).with(1).and_return(false)
        get :show, params:{id: "1"}
        expect(response).to redirect_to(root_path)
      end


    end

    describe "ruolo store" do

    end
  end


  describe 'delete destroy' do
    before(:each) do
      allow(Store).to receive(:find).with("1").and_return(@fake_store.stores[0])
    end

    describe "autorizzato" do
      before(:each) do
          allow(controller).to receive(:authorize!).with(:destroy,@fake_store.stores[0]).and_return("passed!")
          allow(@fake_store).to receive(:include?).with(1).and_return(true)
          allow(@fake_store.stores[0]).to receive(:destroy).and_return(true)
          allow(controller).to receive(:current_user).and_return(@fake_user_store)
          allow(@fake_user_store).to receive(:update).with(roles_mask: 0).and_return(true)
      end

      it " ritorna pagina" do
          delete :destroy, params:{ id: "1"}
          expect(response).to redirect_to(root_path)
      end

      it "cambia ruolo" do
          expect(@fake_user_store).to receive(:update).with(roles_mask: 0)
          delete :destroy, params:{ id: "1"}
      end

    end


  end

#da finire questi test
  describe 'Get new' do
    describe 'autorizzato' do
      it "rendirizza la pagina" do
        allow(controller).to receive(:current_user).and_return(@fake_user_client)
        allow(@fake_user_client).to receive(:admin?).and_return(false)
        allow(controller).to receive(:authorize!).and_return(true)
        get :new
        expect(response).to render_template(:new)
      end
    end

  end

  describe 'POST create' do
    before(:each) do
        @params={store:{name: "prova", location: "roma"}}
    end

    describe "autorizzato" do
      before(:each) do
        allow(controller).to receive(:current_user).and_return(@fake_user_client)
        allow(@fake_user_client).to receive(:update).with(roles_mask: 1).and_return(true)
      end

      it "i parametri sono giusti" do
        post :create, @params
        expect(response).to redirect_to(store_path(assigns(:store)))
      end

      it "testiamo le funzioni usate" do
        allow(Store).to receive(:new).with(@params).and_return(@fake_store.stores[0])
        allow(@fake_store.stores[0]).to receive(:save).and_return(true)
        allow(@fake_store.stores[0]).to receive(:owner_id=).and_return(1)
        allow(controller).to receive(:store_params).and_return(@params)
        expect(Store).to receive(:new).with(@params)
        expect(@fake_store.stores[0]).to receive(:save)
        post :create, @params
      end

      it "i parametri sono sbaglaiti"do
        post :create, store:{name: "prova"}
        expect(response).to render_template(:new)
        post :create, store:{location: "roma"}
        expect(response).to render_template(:new)
      end
    end
  end

describe "upvote e downvote store" do
  before(:each) do
    allow(Store).to receive(:find).with("1").and_return(@fake_store.stores[0])
  end

  describe "upvote"do
    it "sei autorizzato" do
      allow(controller).to receive(:current_user).and_return(@fake_user_client)
      allow(controller).to receive(:authorize!).with(:upvote, @fake_store.stores[0]).and_return('passed')
      expect(@fake_store.stores[0]).to receive(:upvote_from).with(@fake_user_client)
      put :upvote, params:{id: 1}
      expect(response).to redirect_to(store_path(1))
    end

  end

  describe "downvote" do
    it "sei autorizzato" do
      allow(controller).to receive(:current_user).and_return(@fake_user_client)
      allow(controller).to receive(:authorize!).with(:downvote, @fake_store.stores[0]).and_return('passed')
      expect(@fake_store.stores[0]).to receive(:downvote_from).with(@fake_user_client)
      put :downvote, params:{id: 1}
      expect(response).to redirect_to(store_path(1))
    end

  end
end

describe "follow and unfollo" do
  before(:each) do
    @FollowStore=double("follow",follow: [double("follow1",id: 1),double("follow2", id:2)],:store_id= => true,:user_id= => true )
    allow(FollowStore).to receive(:new).and_return(@FollowStore)
    allow(@FollowStore).to receive(:save).and_return(true)
    allow(FollowStore).to receive(:where).and_return(@FollowStore)
    allow(@FollowStore).to receive(:destroy_all).and_return(true)
  end

  describe "follow" do
    it "autorizzato" do
      allow(controller).to receive(:current_user).and_return(@fake_user_client)
      allow(controller).to receive(:authorize!).and_return('passed!')

      expect(FollowStore).to receive(:new)
      expect(@FollowStore).to receive(:save)
      post :follow, params:{id: 1}
      expect(response).to redirect_to(store_path(1))

    end

  end

  describe "unfollow" do
    it "autorizzato" do
      allow(controller).to receive(:current_user).and_return(@fake_user_client)
      allow(controller).to receive(:authorize!).and_return('passed!')

      expect(FollowStore).to receive(:where)
      expect(@FollowStore).to receive(:destroy_all)
      post :unfollow, params:{id: 1}
      expect(response).to redirect_to(store_path(1))

    end
  end

end

describe "choose_yes e choose_no" do
  before(:each) do
    @fake_work=double("work")
    allow(@fake_user_client).to receive(:update).with(roles_mask: 2).and_return(true)
    allow(Work).to receive(:where).with(user_id: @fake_user_store.id, store_id: "1").and_return(@fake_work)
    allow(@fake_work).to receive(:update).and_return(true)
    allow(@fake_work).to receive(:destroy_all).and_return(true)

  end

  describe "choose_yes" do

    it "autorizzato" do
      allow(controller).to receive(:current_user).and_return(@fake_user_client)
      allow(controller).to receive(:authorize!).and_return("passed!")
      expect(@fake_user_client).to receive(:update)
      expect(Work).to receive(:where).with(user_id: @fake_user_store.id, store_id: "1")
      expect(@fake_work).to receive(:update).with(accept: true)
      post :choose_yes, params:{id: 1}
      expect(response).to redirect_to(store_path(1))
    end

  end

  describe "choose_no" do

    it "autorizzato" do
      allow(controller).to receive(:current_user).and_return(@fake_user_client)
      allow(controller).to receive(:authorize!).and_return("passed!")
      #expect(@fake_user_client).to receive(:update)
      expect(Work).to receive(:where).with(user_id: @fake_user_store.id, store_id: "1")
      expect(@fake_work).to receive(:destroy_all)
      post :choose_no, params:{id: 1}
      expect(response).to redirect_to(root_path)
    end


  end
end

describe "change_admin" do
  before(:each) do
    @fake_work=double("work" )
    allow(@fake_store.stores[0]).to receive(:update).with(owner_id: "2")
    allow(User).to receive(:find).with(2).and_return(@fake_user_client)
    allow(Work).to receive(:where).and_return(@fake_work)
    allow(@fake_user_store).to receive(:update)
  end

  describe "autorizzato" do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(@fake_user_store)
    end

    it "va a buon fine" do
      allow(controller).to receive(:authorize!).and_return("passed!")
      allow(@fake_work).to receive(:exists?).and_return(true)
      expect(@fake_work).to receive(:exists?).and_return(true)
      expect(@fake_user_store).to receive(:update).with(roles_mask: 2)
      post :change_admin,params:{id:1,user_id: 2}
      expect(response).to redirect_to(store_path(1))
      expect(flash[:error]).to_not eq("non puoi nominare questo utente")
    end

    it "non esiste l'utente" do
      allow(controller).to receive(:authorize!).and_return("passed!")
      allow(@fake_work).to receive(:exists?).and_return(false)
      expect(@fake_work).to receive(:exists?).and_return(false)
      expect(@fake_user_store).to_not receive(:update)
      post :change_admin,params:{id:1,user_id: 2}
      expect(response).to redirect_to(store_path(1))
      expect(flash[:error]).to eq("non puoi nominare questo utente")
    end
  end



end

describe "leave_store" do
  before(:each) do
    @fake_work=double("work",destroy_all: true)
    allow(Work).to receive(:where).and_return(@fake_work)
    allow(@fake_user_store).to receive(:update).and_return(true)
  end

  describe "autorizzato" do
    before(:each) do
    end

    it "va a buon fine" do
      allow(controller).to receive(:current_user).and_return(@fake_user_store)
      allow(@fake_work).to receive(:exists?).and_return(true)
      allow(controller).to receive(:authorize!).and_return(true)
      expect(@fake_work).to receive(:destroy_all)
      get :leave_store,params:{id:1,store_id:1}
      expect(response).to redirect_to(root_path)
    end

    it "non va a buon fine" do
      allow(controller).to receive(:current_user).and_return(@fake_user_store)
      allow(@fake_work).to receive(:exists?).and_return(false)
      allow(controller).to receive(:authorize!).and_return(true)
      expect(@fake_work).to_not receive(:destroy_all)
      get :leave_store,params:{id:1,store_id:1}
      expect(response).to redirect_to(root_path)
    end

  end
end

describe "show_photo" do
  it "render a template" do
    #allow(controller).to receive(:authorize!).and_return(true)
    d=double("foto",exists?: true)
    allow(PhotoStore).to receive(:where).and_return(d)
    allow(PhotoStore).to receive(:find).and_return(d)
    get :show_photo, params:{id: 1, picture_id: 2}
    expect(response).to render_template(:show_photo)
  end

  it "render a template home" do
    #allow(controller).to receive(:authorize!).and_return(true)
    allow(PhotoStore).to receive(:where).and_return(double("foto",exists?: false))
    get :show_photo, params:{id: 1, picture_id: 2}
    expect(response).to redirect_to(root_path)
  end
end

describe "destroy_comment" do
  it "destroy" do
    @photo=double("foto",exists?: true,destroy_all: true)
    allow(PhotoStore).to receive(:where).and_return(@photo)
    delete :destroy_photo, params:{id: 1, picture_id: 1}
    expect(response).to redirect_to(store_path(1))
  end

  it "not destroy" do
    @photo=double("foto",exists?: false,destroy_all: false)
    allow(PhotoStore).to receive(:where).and_return(@photo)
    expect(@photo).to_not receive(:destroy_all)
    delete :destroy_photo, params:{id: 1, picture_id: 1}
    expect(response).to redirect_to(store_path(1))
  end
end

end

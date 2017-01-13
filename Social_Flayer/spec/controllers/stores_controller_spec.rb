require 'rails_helper'

RSpec.describe StoresController, type: :controller do


  describe  "GET INDEX" do
    before(:each) do
      @fake_result=[double('store1'),double('store2')]
      allow(Store).to receive(:all).and_return(@fake_result)
      get :index
    end
    it 'testare la rout' do
      expect(response).to render_template('index')
    end

    it 'test result' do
      expect(assigns(:stores)).to eq(@fake_result)
    end
  end

  describe 'GET SHOW' do
    before(:each) do
      @fake_result=double('store1')
      allow(@fake_result).to receive(:id).and_return("1")
      allow(Store).to receive(:find).with(@fake_result.id).and_return(@fake_result)
      get :show, params: { id: 1 }
    end

    it 'testare la rout' do
      expect(response).to render_template('show')
    end

    it 'test result' do
      expect(assigns(:show)).to eq(@fake_result)
    end
  end


#da finire questi test
  describe 'Get new' do
    it "prova" do
      @fake_user=double('User')
      allow(@fake_user).to receive(:id).and_return("1")

      allow(controller).to receive(:current_user).and_return(@fake_user)
      get "new"
    expect(response).to render_template(:new)

    post "create", :store => {:name => "My Widget",:location=> "roma"}

    expect(response).to redirect_to("/stores/1")

    end
  end




end

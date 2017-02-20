require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  before(:each) do
    @fake_user=double('User', id: 1, roles_mask: 0)
    @fake_user2=double('User', id: 1, roles_mask: 1)
  end
  controller do
    def index
      raise CanCan::AccessDenied
    end

    def show
      raise ActionController::RoutingError.new(params[:id])
    end
  end

  describe "eccezioni can can" do

    it "role mask = 0" do
      allow(controller).to receive(:current_user).and_return(@fake_user)
      get :index
      expect(response).to redirect_to(root_path)

    end

    it "rolemask = 1 " do

      allow(controller).to receive(:current_user).and_return(@fake_user2)
      cookies[:last_store]=1
      get :index
      expect(response).to redirect_to(store_path(1))

    end

  end

  describe "lost_connection" do
    it "lost_connection" do
      get :show, params:{id: "lost_connection"}
      expect(response).to render_template(:file => "#{Rails.root}/public/500.html")
    end

    it "not found" do
      get :show, params:{id: "not found"}
      expect(response).to render_template(:file => "#{Rails.root}/public/404.html")
    end

  end




end

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'routes' do
    it "return home" do
      expect(get: root_url(subdomain: nil)).to route_to(controller: "users",action: "home")
    end


  end
end

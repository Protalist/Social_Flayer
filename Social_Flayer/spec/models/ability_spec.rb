require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  before(:each) do
    @user=User.create(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
    @use2r=User.create(:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all2')
    @ability=Ability.new(@user)
  end

  context "a guest user" do
    it "should be able to manage self" do
      expect(@ability).to be_able_to(:crud, @user)
    end

    it "should not be able to manage others" do
      expect(@ability).to_not be_able_to(:crud, @User2)
    end
  end
end

require 'rails_helper'
require 'user'

RSpec.describe User, type: :model do
  before(:each) do
    @aldo=User.new(:email => 'test@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
    @aldo2=User.new(:email => 'test2@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'all')
  end
  it "is valid with valid attributes"do
    expect(@aldo).to be_valid
  end

  describe "is not valid without a name " do
    it "is not valid without name" do
      @aldo.name=nil
      expect(@aldo).to_not be_valid
    end

    it "is not valid without surname" do
      @aldo.surname=nil
      expect(@aldo).to_not be_valid
    end

    it "is not valid without username" do
      @aldo.username=nil
      expect(@aldo).to_not be_valid
    end
  end

  it "is not valid with two username equals" do
    @aldo2.save
    expect(@aldo).to_not be_valid
  end


end

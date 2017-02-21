require 'rails_helper'

RSpec.describe FollowerUser, type: :model do

  before(:each) do
    @follow_user1 = FollowerUser.new(follower_id:1,followed_id:2)
    expect(@follow_user1).to_not eq(nil)

  end
  describe "validiamo il follow" do
    it "è ok" do
      expect(@follow_user1).to be_valid
    end
    it "follwer_id nullo" do
       @follow_user1.follower_id=nil
       expect(@follow_user1).to_not be_valid
       @follow_user1.follower_id=""
       expect(@follow_user1).to_not be_valid
    end
    it "follwed_id nullo" do
       @follow_user1.followed_id=nil
       expect(@follow_user1).to_not be_valid
       @follow_user1.followed_id=""
       expect(@follow_user1).to_not be_valid
    end
    it "test unicità" do
      @follow_user1.save
      @follow_user2 = FollowerUser.new(follower_id:1,followed_id:2)
      expect(@follow_user2).to_not be_valid
    end

  end
  describe "associazioni" do
     it "follower" do
        assc = described_class.reflect_on_association(:follower)
        expect(assc.macro).to eq :belongs_to
        expect(assc.options).to eq(class_name:"User",foreign_key: "user.id")
      end
      it "followed" do
        assc = described_class.reflect_on_association(:followed)
        expect(assc.macro).to eq :belongs_to
        expect(assc.options).to eq(class_name:"User",foreign_key: "user.id")
      end
  end
  describe FollowerUser do
    it "non posso seguire me stesso" do
      @follow_user2 = FollowerUser.new(follower_id:1,followed_id:1)
      expect(@follow_user2).to_not be_valid

    end
  end


end

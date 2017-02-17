require 'rails_helper'

RSpec.describe FollowStore, type: :model do
   before(:each) do
     @follow_store1 =FollowStore.new(user_id:1,store_id:1)
     expect(@follow_store1).to_not eq(nil)
   end
   describe "validiamo il follow" do
     it "è valido" do
        expect(@follow_store1).to be_valid
     end
     it "user nullo" do
       @follow_store1.user_id=nil
       expect(@follow_store1).to_not be_valid
       @follow_store1.user_id=""
       expect(@follow_store1).to_not be_valid
     end
     it "store nullo" do
       @follow_store1.store_id=nil
       expect(@follow_store1).to_not be_valid
       @follow_store1.store_id=""
       expect(@follow_store1).to_not be_valid
     end
     it "test unicità" do
       @follow_store1.save
       @follow_store2 = FollowStore.new(user_id:1,store_id:1)
       expect(@follow_store2).to_not be_valid
     end
   end
   describe "associazioni" do
     it "user_id" do
        assc = described_class.reflect_on_association(:user)
        expect(assc.macro).to eq :belongs_to
      end
      it "store_id" do
        assc = described_class.reflect_on_association(:store)
        expect(assc.macro).to eq :belongs_to
      end

   end
    

end


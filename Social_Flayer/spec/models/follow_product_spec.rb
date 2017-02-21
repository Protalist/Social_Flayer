require 'rails_helper'

RSpec.describe FollowProduct, type: :model do
  before(:each) do
    @follow_product =FollowProduct.new(user_id:1,product_id:1)
    expect(@follow_product).to_not eq(nil)
  end
  describe "validiamo il follow" do
    it "è valido" do
       expect(@follow_product).to be_valid
    end
    it "user nullo" do
      @follow_product.user_id=nil
      expect(@follow_product).to_not be_valid
      @follow_product.user_id=""
      expect(@follow_product).to_not be_valid
    end
    it "store nullo" do
      @follow_product.product_id=nil
      expect(@follow_product).to_not be_valid
      @follow_product.product_id=""
      expect(@follow_product).to_not be_valid
    end
    it "test unicità" do
      @follow_product.save
      @follow_product2 = FollowProduct.new(user_id:1,product_id:1)
      expect(@follow_product2).to_not be_valid
    end
  end
  describe "associazioni" do
    it "user_id" do
       assc = described_class.reflect_on_association(:user)
       expect(assc.macro).to eq :belongs_to
     end
     it "product_id" do
       assc = described_class.reflect_on_association(:product)
       expect(assc.macro).to eq :belongs_to
     end

  end
end

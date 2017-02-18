require 'rails_helper'

RSpec.describe Work, type: :model do

  before(:each) do
    @work_user = Work.new(store_id:1,user_id:1)
    expect(@work_user).to_not eq(nil)
  end

  describe "validates" do
    it "è ok" do
      expect(@work_user).to be_valid
    end
    it "test unicità" do
      @work_user.save
      @work_user2 = Work.new(store_id:1,user_id:1)
      expect(@work_user2).to_not be_valid
    end

  end
  describe "associazioni" do
     it "store" do
        assc = described_class.reflect_on_association(:store)
        expect(assc.macro).to eq :belongs_to
      end
      it "user" do
        assc = described_class.reflect_on_association(:user)
        expect(assc.macro).to eq :belongs_to
      end
  end

end

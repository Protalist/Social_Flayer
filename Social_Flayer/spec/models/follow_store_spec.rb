require 'rails_helper'

RSpec.describe FollowStore, type: :model do
  
  describe "test sulle associazioni" do
    it "store belongs_to" do
      assc= described_class.reflect_on_association(:store)
      expect(assc.macro).to eq :belongs_to
    end

    it "user belongs_to" do
      assc= described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

  end

end

require 'rails_helper'

RSpec.describe Respond, type: :model do
  describe "associazioni" do
     it "store" do
        assc = described_class.reflect_on_association(:store)
        expect(assc.macro).to eq :belongs_to
      end
      it "comment" do
        assc = described_class.reflect_on_association(:comment)
        expect(assc.macro).to eq :belongs_to
      end
  end
end

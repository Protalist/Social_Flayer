require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @commento1 = Comment.new(user_id:1,store_id:1,content:"cosenoncose",comment_id:1)
    expect(@commento1).to_not eq(nil)
  end
  describe "validiamo commento" do
      it "è valido" do
        expect(@commento1).to be_valid
      end

      it "nome nullo" do
        @commento1.user_id=nil
        expect(@commento1).to_not be_valid
        @commento1.user_id=""
        expect(@commento1).to_not be_valid
      end


      it "content nullo" do
        @commento1.content=""
        expect(@commento1).to_not be_valid
        @commento1.content=nil
        expect(@commento1).to_not be_valid
      end

      it "store nullo" do
        @commento1.store_id=""
        expect(@commento1).to_not be_valid
        @commento1.store_id=nil
        expect(@commento1).to_not be_valid
      end
       
      
    end
    describe "test associazioni" do
      it "user_id" do
        assc = described_class.reflect_on_association(:user)
        expect(assc.macro).to eq :belongs_to
      end
      it "store_id" do
        assc = described_class.reflect_on_association(:store)
        expect(assc.macro).to eq :belongs_to
      end
      it "primary" do
        assc = described_class.reflect_on_association(:primary)
        expect(assc.macro).to eq :belongs_to
        expect(assc.options).to eq(class_name:"Comment")
      end
      it "replys" do
        assc = described_class.reflect_on_association(:replys)
        expect(assc.macro).to eq :has_many
        expect(assc.options).to eq(class_name:"Comment",dependent: :destroy)
      end
      it "responds" do
        assc = described_class.reflect_on_association(:responds)
        expect(assc.macro).to eq :has_many
      end
   end
end

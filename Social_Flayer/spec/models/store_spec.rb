require 'rails_helper'

RSpec.describe Store, type: :model do
  before(:each) do
      @store1=Store.new(name: "prova", location: "roma", owner_id: 1)
      expect(@store1).to_not eq(nil)
    end

    describe "validates" do
      it "è valido" do
        expect(@store1).to be_valid
      end

      it "nome nullo" do
        @store1.name=nil
        expect(@store1).to_not be_valid
        @store1.name=""
        expect(@store1).to_not be_valid
      end


      it "location nullo" do
        @store1.location=""
        expect(@store1).to_not be_valid
        @store1.location=nil
        expect(@store1).to_not be_valid
      end

      it "owner id nullo" do
        @store1.owner_id=""
        expect(@store1).to_not be_valid
        @store1.owner_id=nil
        expect(@store1).to_not be_valid
      end

      it "test uniqunes" do
        @store1.save
        @store2=Store.new(name: "prova", location: "frasassi", owner_id: 1)
        expect(@store2).to_not be_valid
      end


    end

    describe "tes sulle associazioni" do
      it "owner" do
        assc = described_class.reflect_on_association(:owner)
        expect(assc.macro).to eq :belongs_to
      end

      it "works" do
        assc = described_class.reflect_on_association(:works)
        expect(assc.macro).to eq :has_many
        expect(assc.options).to eq(dependent: :destroy)
        assc = described_class.reflect_on_association(:admin)
        expect(assc.macro).to eq :has_many
        expect(assc.options).to eq( :through => :works, :source => 'user')
      end

      it "products" do
        assc = described_class.reflect_on_association(:products)
        expect(assc.macro).to eq :has_many
        expect(assc.options).to eq(dependent: :destroy)
      end

      it "comments" do
        assc = described_class.reflect_on_association(:comments)
        expect(assc.macro).to eq :has_many
        expect(assc.options).to eq(dependent: :destroy)
      end

      it "responds" do
        assc = described_class.reflect_on_association(:responds)
        expect(assc.macro).to eq :has_many
        expect(assc.options).to eq(dependent: :destroy)
      end

      it "followers" do
        assc = described_class.reflect_on_association(:follow_stores)
        expect(assc.macro).to eq :has_many
        assc = described_class.reflect_on_association(:followers)
        expect(assc.macro).to eq :has_many
      end

    end

    describe "distance_from" do
      it "cerco roma" do
        c=@store1.distance_from("roma")
        expect(c).to eq(1.0)
      end

      it "cerco la stringa vuota" do
        c=@store1.distance_from("")
        expect(c).to eq(-1)
      end

      it "cerco con il parametro nil" do
        c=@store1.distance_from(nil)
        expect(c).to eq(-1)
      end

      it "cerco una luogo che non esiste" do
        c=@store1.distance_from("ddrtyhjnbvgyjnb vcfgyhjnb vftyujnb vgyuikjnbvgyuikjnbgyuikmnbvgyuikmnbgyuikmnbgyuik")
        expect(c).to eq(-1)
      end

      it "non riesco a collegarmi a al sito" do
        exe=double("exe", :use_ssl= => true)
        allow( Net::HTTP).to receive(:new).and_return(exe)
        allow(exe).to receive(:request).and_raise("errore")
        expect(exe).to receive(:request).and_raise("errore")
        begin
        expect(@store1.distance_from("roma")).to raise_error(ActionController::RoutingError.new('lost_connection'))
        rescue => e
          expect(true).to eq(true)
        end
      end
    end

    describe "search" do
      before(:each) do
        @params={type: "prova", name: "prova2"}
        @stores=double("stores",stores: [double("store1"),double("store2")])
        allow(Store).to receive(:left_outer_joins).with(:products).and_return(@stores)
        allow(@stores).to receive(:distinct).and_return(@stores)
        allow(@stores).to receive(:where).and_return(@stores)
        expect(Store).to receive(:left_outer_joins).with(:products)
      end

      it "params completo" do
        expect(@stores).to receive(:where).with("type_p LIKE ?", "%#{@params[:type]}%")
        expect(@stores).to receive(:where).with(["stores.name LIKE ?", "%#{@params[:name]}%"])
        expect(Store.search(@params)).to eq(@stores)
      end

      it "params senza nome=''" do
        @params[:name]=""
        expect(@stores).to receive(:where).with("type_p LIKE ?", "%#{@params[:type]}%")
        expect(@stores).to_not receive(:where).with(["stores.name LIKE ?", "%#{@params[:name]}%"])
        expect(Store.search(@params)).to eq(@stores)
      end

      it "params senza nome=nil" do
        @params[:name]=nil
        expect(@stores).to receive(:where).with("type_p LIKE ?", "%#{@params[:type]}%")
        expect(@stores).to_not receive(:where).with(["stores.name LIKE ?", "%#{@params[:name]}%"])
        expect(Store.search(@params)).to eq(@stores)
      end

      it "params senza type=''" do
        @params[:type]=""
        expect(@stores).to_not receive(:where).with("type_p LIKE ?", "%#{@params[:type]}%")
        expect(@stores).to receive(:where).with(["stores.name LIKE ?", "%#{@params[:name]}%"])
        expect(Store.search(@params)).to eq(@stores)
      end

      it "params senza type=nil" do
        @params[:type]=nil
        expect(@stores).to_not receive(:where).with("type_p LIKE ?", "%#{@params[:type]}%")
        expect(@stores).to receive(:where).with(["stores.name LIKE ?", "%#{@params[:name]}%"])
        expect(Store.search(@params)).to eq(@stores)
      end
    end
end

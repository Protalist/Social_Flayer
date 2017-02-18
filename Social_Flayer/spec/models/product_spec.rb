require 'rails_helper'

RSpec.describe Product, type: :model do
  
  before(:each) do
      @product1=Product.new(name: "prova", store_id:1 ,id:1, price:1, type_p:1, duration_h:1)
      expect(@product1).to_not eq(nil)
      allow(@product1).to receive(:number_products).and_return(@product1)
  end

  describe "validates" do
    it "è valido" do
      expect(@product1).to be_valid
    end

    it "nome nullo" do
      @product1.name=nil
      expect(@product1).to_not be_valid
      @product1.name=""
      expect(@product1).to_not be_valid
    end

    it "prezzo nullo" do
      @product1.price=""
      expect(@product1).to_not be_valid
      @product1.price=nil
      expect(@product1).to_not be_valid
    end

    it "type_p nullo" do
      @product1.type_p=""
      expect(@product1).to_not be_valid
      @product1.type_p=nil
      expect(@product1).to_not be_valid
    end

    it "duration nullo" do
      @product1.duration_h=nil
      expect(@product1).to_not be_valid
      @product1.duration_h=""
      expect(@product1).to_not be_valid
    end

    it "test unicità" do
      @product1.save
      @product2=Product.new(name: "prova", id:2, store_id:1 ,price:2, type_p:3, duration_h:3)
      allow(@product2).to receive(:number_products).and_return(@product2)
      expect(@product2).to_not be_valid
    end

  end

  describe "test sulle associazioni" do
    it "store belongs_to" do
      assc= described_class.reflect_on_association(:store)
      expect(assc.macro).to eq :belongs_to
    end

  end
end

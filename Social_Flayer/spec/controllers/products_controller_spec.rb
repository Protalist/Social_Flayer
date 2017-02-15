require 'rails_helper'



RSpec.describe ProductsController, type: :controller do
  before(:each) do

       @fake_user_client=double('User', id: 1, roles_mask: 0)
       @fake_user_store=double('USer',id: 1, roles_mask: 1)
       @fake_store=double('Stores', stores: [double("store1",id:1),double("store2",id:2)])
       @fake_products=double('Product', id:1, price:1, type_p:1, duration_h:1)
      allow(Product).to receive(:ids).and_return(@fake_products)
   end


   describe  "Show" do
     before(:each) do
       allow(Store).to receive(:find).with("1").and_return(@fake_store.stores[0])
       allow(Product).to receive(:find).with("1").and_return(@fake_store.stores[0])
       allow(@fake_store.stores[0]).to receive(:products).and_return(@fake_producs)
     end

     it "prodotto esistente" do
         get :show, params:{id: "1"}
         expect(response).to render_template(:show)
     end

     end



  it "prova" do
    @fake_result=double("products")

    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user=User.create(:email => 'test6@example.com', :password => 'password', :password_confirmation => 'password',:name => 'aldo', :surname => 'baglio', :username=> 'aall')
    expect(@user).to_not eq(nil)
    sign_in @user

    allow(Product).to receive(:find).with("1").and_return(@fake_result)
    allow(Store).to receive(:find).with("1").and_return(double("store"))
    allow(controller).to receive(:authorize!).with(:show,@fake_result).and_return('passed!')
    #expect(subject.current_user).to receive(:can?).and_return(true)
    #expect(@user).to be_able_to(:show, Product.new)
    get :show, params: {:store_id => "1",:id => "1"}
    expect(response).to render_template(:show)
  end



end

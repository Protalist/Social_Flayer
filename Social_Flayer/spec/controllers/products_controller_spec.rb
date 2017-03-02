require 'rails_helper'



RSpec.describe ProductsController, type: :controller do
  before(:each) do
       @fake_user_client=double('User', id: 1, roles_mask: 0,ban:0)
       @fake_user_store=double('USer',id: 1, roles_mask: 1,ban: 0)
       @fake_products=double('Product', id:1, price:1, type_p:1, duration_h:1, store_id: 1)
       @fake_store=double('Stores', stores: [double("store1",id:1 ,products: @fake_products),double("store2",id:2)])
       allow(controller).to receive(:authorize!).and_return(true)
       allow(Product).to receive(:ids).and_return(@fake_products)
       allow(Product).to receive(:find).and_return(@fake_products)
       allow(@fake_products).to receive(:include?).and_return(true)
   end

   describe "get show" do
     it " ritorna il template" do
       allow(Store).to receive(:find).and_return(@fake_store.stores[0])
       get :show, params:{id: 1,store_id: 1}
       expect(assigns(:product)).to eq(@fake_products)
       expect(assigns(:store)).to eq(@fake_store.stores[0])
       expect(response).to render_template(:show)
     end
   end

   describe "get new" do
     before(:each) do
       allow(Product).to receive(:new).and_return(@fake_products)
     end

     it "chiamata tramite html" do
       get :new, params:{store_id:1}
       expect(response).to render_template(:new)
     end

     it "chiamata tramite ajax" do
       post :new, params:{store_id:1, format: :js}
       expect(response).to render_template(:new)
     end
   end

   describe "post create" do
     before(:each) do
      @params={name: "name", price: 1, duration_h: 10, feature: "feature", type_p: "p"}
      allow(Store).to receive(:find).and_return(@fake_store.stores[0])
      allow(@fake_products).to receive(:build).and_return(@fake_products)
     end

     it "chiamata con argomenti esatti"do
        allow(@fake_products).to receive(:save).and_return(true)
       post :create, params:{store_id: 1, product: @params}
       expect(response).to redirect_to(store_path(1))
     end

     it "chiamata con argomenti sbagliati"do
      allow(@fake_products).to receive(:save).and_return(false)
       post :create, params:{store_id: 1, product: @params}
       expect(response).to render_template(:new)
     end
   end

   describe "get edit" do
     it "chiamo tramite html" do
       get :edit, params:{store_id:1,id:1}
       expect(response).to render_template(:edit)
     end

     it "chiamata tramite js" do
       post :edit, params:{store_id:1,id:1, format: :js}
       expect(response).to render_template(:edit)
     end
   end

   describe "update" do
     before(:each) do
      @params={name: "name", price: 1, duration_h: 10, feature: "feature", type_p: "p"}
      allow(Store).to receive(:find).and_return(@fake_store.stores[0])
    end

     it "parametri giusti" do
        allow(@fake_products).to receive(:update).and_return(true)
        post :update, params:{store_id: 1, id:1, product: @params}
        expect(response).to redirect_to(store_path(1))
     end

     it "parametri sbagliati" do
       allow(@fake_products).to receive(:update).and_return(false)
       post :update, params:{store_id: 1, id:1, product: @params}
       expect(response).to render_template(:edit)
     end

   end

   describe "desctroy" do
     it "cancella prodotto" do
       expect(@fake_products).to receive(:destroy).and_return(true)
       delete :destroy, params:{store_id: 1, id: 1}
       expect(response).to redirect_to(store_path(1))
     end
   end
   #testiamo il metodo privato

   describe "product" do
     before(:each) do
       allow(controller).to receive(:params).and_return({id: "1"})
     end

     it "il prodotto esiste"do
      expect(Product).to receive(:find)
      controller.send(:product)
      expect(assigns(:product)).to eq(@fake_products)
     end

     it "prodotto non esiste" do
       allow(@fake_products).to receive(:include?).and_return(false)
       expect(Product).to_not receive(:find)
       expect(controller).to receive(:redirect_to).with(root_path)
       controller.send(:product)
     end

   end


end

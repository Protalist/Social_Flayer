require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  before(:each) do
    @user=double("user",id: 1)
  end

 describe "show_report" do
   it "chiamata tramite html" do
     get :show_report, params:{id: 2}
     expect(response).to render_template(:show_report)
   end

   it "chiamata tramite js" do
     post :show_report, params:{id: 2, format: :js}
     expect(response).to render_template(:show_report)
   end
 end

 describe "report" do
   it "report funziona" do
     @user2=double("user2", exists?: true)
     @report=double("report", :reported_id= => true, :reporter_id= => true, save: true)
     allow(Report).to receive(:new).and_return(@report)
     allow(controller).to receive(:current_user).and_return(@user)
     allow(User).to receive(:where).and_return(@user2)
     post :report, params:{id: 2, report:{motivation: "prova"}}
     expect(response).to redirect_to(user_path(2))
     expect(flash[:alert]).to eq("report inviato")
   end

   it "report il report è già stato fatto" do
     @user2=double("user2", exists?: true)
     @report=double("report", :reported_id= => true, :reporter_id= => true, save: false)
     allow(Report).to receive(:new).and_return(@report)
     allow(controller).to receive(:current_user).and_return(@user)
     allow(User).to receive(:where).and_return(@user2)
     post :report, params:{id: 2, report:{motivation: "prova"}}
     expect(response).to redirect_to(user_path(2))
      expect(flash[:alert]).to eq("report non riuscito")
   end

   it "non esiste l'utente" do
     @user2=double("user2", exists?: false)
     allow(controller).to receive(:current_user).and_return(@user)
     allow(User).to receive(:where).and_return(@user2)
     post :report, params:{id: 2, report:{motivation: "prova"}}
     expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("non esiste questo utente")
   end
 end
end

require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  before(:each) do
    @user=double("user",id: 1, ban:0)
    @user2=double("user2", exists?: true)
    allow(controller).to receive(:authorize!).and_return(true)
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
     @report=double("report", :reported_id= => true, :reporter_id= => true, save: true)
     allow(User).to receive(:find).and_return(@user2)
     allow(Report).to receive(:new).and_return(@report)
     allow(controller).to receive(:current_user).and_return(@user)
     allow(User).to receive(:where).and_return(@user2)
     post :report, params:{id: 2, report:{motivation: "prova"}}
     expect(response).to redirect_to(user_path(2))
     expect(flash[:alert]).to eq("report inviato")
   end

   it "report il report è già stato fatto" do
     allow(User).to receive(:find).and_return(@user2)
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

 describe "show ban"  do
   it "render template" do
     expect(Report).to receive(:where)
     get :show_ban, params:{id:2}
     expect(response).to render_template(:show_ban)
   end
 end

 describe "send_ban" do
   describe "caso esiste l'utente da bannare" do
      before(:each) do
        @report=double("report", exists?: true,destroy_all: true)
        allow(Report).to receive(:where).and_return(@report)
        allow(User).to receive(:find).and_return(@user2)
        allow(@user2).to receive(:update).and_return(true)
      end

      it "ban temporaneo" do
        data=Time.now()+12345.day
        expect(@user2).to receive(:update).with(ban: data.to_i)
        post :send_ban, params:{id: 2,ban:{day: 12345}}
      end

      it "ban permanente" do
        expect(@user2).to receive(:update).with(ban: -1)
        post :send_ban, params:{id: 2,ban:{day: -1}}
      end

      it "assolto" do
        expect(@user2).to_not receive(:update)
        post :send_ban, params:{id: 2,ban:{day: 0}}
      end
   end

   it "report non esiste" do
     @report=double("report", exists?: false,destroy_all: true)
     post :send_ban, params:{id: 2,ban:{day: 0}}
     expect(flash[:alert]).to eq("non esiste il report")
   end
 end


end

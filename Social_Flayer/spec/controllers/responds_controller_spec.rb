

require 'rails_helper'

RSpec.describe RespondsController, type: :controller do
    before(:each) do
        @fake_resp = double("Resp",id:1,store_id:1,comment_id:1,content:"ciaone")
        @fake_store = double("Store") 
        allow(Respond).to receive(:ids).and_return(@fake_resp)
    end
    describe "POST CREATE" do
        before(:each) do
            allow(Respond).to receive(:new).and_return(@fake_resp)
            allow(@fake_resp).to receive(:store_id=).and_return(1)
            allow(@fake_resp).to receive(:comment_id=).and_return(1)
        end
        describe "risposta del negozio" do
            describe "html" do
                it "risponde bene" do
                    allow(controller).to receive(:authorize!).and_return("passed")
                    allow(@fake_resp).to receive(:save).and_return(true)
                    expect(@fake_resp).to receive(:save)
                    post :create, params: {store_id:1,comment_id:1,respond:{content:@fake_resp.content}}
                    expect(response).to redirect_to(store_path(1))
                end
                it "rispondo male (vuota)" do
                    allow(controller).to receive(:authorize!).and_return("passed")
                    allow(@fake_resp).to receive(:save).and_return(false)
                    expect(@fake_resp).to receive(:save)
                    post :create, params: {store_id:1,comment_id:1,respond:{content:""}}
                    expect(response).to redirect_to(store_path(1))
                end

            end
            describe "js" do
                it "risponde bene" do 
                    allow(controller).to receive(:authorize!).and_return("passed")
                    allow(@fake_resp).to receive(:save).and_return(true)
                    expect(@fake_resp).to receive(:save)
                    post :create, params: {store_id:1,comment_id:1,respond:{content:@fake_resp.content},format: "js"}
                    expect(response).to render_template("create")
                end
                it "non risponde bene" do
                    allow(controller).to receive(:authorize!).and_return("passed")
                    allow(@fake_resp).to receive(:save).and_return(false)
                    expect(@fake_resp).to receive(:save)
                    post :create, params: {store_id:1,comment_id:1,respond:{content:""},format: "js"}
                    expect(response).to render_template("shared/nothing")
                end
            end

        end
        
    end
    describe "edit" do
            before(:each) do 
                allow(@fake_resp).to receive(:include?).with(1).and_return(true)
                allow(Respond).to receive(:find).with("1").and_return(@fake_resp)

            end
            it "con js" do
                allow(controller).to receive(:authorize!).and_return(true)
                post :edit ,params:{store_id:1,comment_id:1,id:1,format: "js"}
                expect(response).to render_template("edit")
            end
    end
    describe "update" do
        before(:each) do
            allow(@fake_resp).to receive(:include?).with(1).and_return(true)
            allow(Respond).to receive(:find).with("1").and_return(@fake_resp)
        end
        it "modifica" do
            allow(controller).to receive(:authorize!).and_return("passed")
            allow(@fake_resp).to receive(:update).and_return(@fake_resp)
            put :update, params: {store_id:1,comment_id:1,id:1,respond:{content:"update"}}
            expect(response).to redirect_to(store_path(1))
        
        end
    end
    describe "destroy" do
        before(:each) do
            allow(@fake_resp).to receive(:include?).with(1).and_return(true)
            allow(Respond).to receive(:find).with("1").and_return(@fake_resp)
            allow(controller).to receive(:authorize!).and_return("passed")
            allow(@fake_resp).to receive(:destroy).and_return(true)
        end
        it "bye bye risposta html" do
            delete :destroy,params:{store_id:1,comment_id:1,id:1}
            expect(response).to redirect_to(store_path(1))
            
        end
        it "bye bye risposta js" do
            delete :destroy,params:{store_id:1,comment_id:1,id:1,format:"js"}
            expect(response).to render_template(:destroy)
        end

    end
    describe "respond" do
      it "la risposta esiste" do
        allow(@fake_resp).to receive(:include?).with(1).and_return(true)
        allow(controller).to receive(:params).and_return({id: "1"})
        expect(Respond).to receive(:find)
        controller.send(:respond)
      end

      it "la risposta non esiste" do
        allow(@fake_resp).to receive(:include?).with(1).and_return(false)
        allow(controller).to receive(:params).and_return({id: "1"})
        expect(controller).to receive(:redirect_to)
        controller.send(:respond)
      end
    end

end

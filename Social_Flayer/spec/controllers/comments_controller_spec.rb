require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
    before(:each) do
        
        @fake_user_comment1 = double("User",id:1,roles_mask:0)
        @fake_user_comment2 = double("User",id:1,roles_mask:1)
       
        @fake_store_comment = double("Store")
        @fake_comment = double("Comment",id:1,content:"ciaone")
        allow(Comment).to receive(:ids).and_return(@fake_comment)
    end
    describe  "POST CREATE" do
        before(:each) do
            allow(Comment).to receive(:new).and_return(@fake_comment)
            @paramsi={comment:{content:"prova"}}
            
            
            allow(@fake_comment).to receive(:store_id=).and_return(1)
            
            
        end
        describe "commentiamo" do
            it "sono un utente semplice ,vedo un negozio lo commento" do
                allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
                allow(controller).to receive(:authorize!).and_return("passed")
                allow(@fake_comment).to receive(:user_id=).and_return(1)
                allow(@fake_comment).to receive(:save).and_return(true)
                post :create , params: {store_id:1,comment:@paramsi}
                expect(response).to redirect_to(store_path(1))

                
                
            end
            it "content=''" do
              allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
              allow(controller).to receive(:authorize!).and_return("passed")
              allow(@fake_comment).to receive(:user_id=).and_return(1)
              allow(@fake_comment).to receive(:save).and_return(false)
              expect(@fake_comment).to receive(:save)
              post :create , params: {store_id:1,comment:@paramsi}
              expect(response).to redirect_to(store_path(1))
            end
            it "non posso commentare" do
                allow(controller).to receive(:current_user).and_return(@fake_user_comment2)
                
                allow(@fake_comment).to receive(:user_id=).and_return(1)
                allow(@fake_comment).to receive(:save).and_return(true)
                cookies[:last_store]=2
                post :create , params: {store_id:1,comment:@paramsi}
                expect(response).to redirect_to(store_path(2))
            end

        end
        
    end
    describe "GET REPLY" do
        before(:each) do
            allow(Comment).to receive(:new).and_return(@fake_comment)
            @paramsi={comment:{content:"prova"}}
            
            
            allow(@fake_comment).to receive(:store_id=).and_return(1)
            allow(@fake_comment).to receive(:comment_id=).and_return(1)
        end
        describe "rispondiamo" do
            it "sono un utente semplice ,vedo un commento e rispondo" do
                allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
                allow(controller).to receive(:authorize!).and_return("passed")
                allow(@fake_comment).to receive(:user_id=).and_return(1)
                allow(@fake_comment).to receive(:save).and_return(true)
                post :reply , params: {store_id:1,id:1,comment:@paramsi}
                expect(response).to redirect_to(store_path(1))
            end
            it "risposta vuota" do
                allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
                allow(controller).to receive(:authorize!).and_return("passed")
                allow(@fake_comment).to receive(:user_id=).and_return(1)
                allow(@fake_comment).to receive(:save).and_return(false)
                post :reply , params: {store_id:1,id:1,comment:@paramsi}
                expect(response).to render_template(nil)
                expect(response).to_not redirect_to(store_path(1))
            end
            it "non posso commentare" do
                expect(@fake_comment).to_not receive(:save)
                allow(controller).to receive(:current_user).and_return(@fake_user_comment2)
                
                allow(@fake_comment).to receive(:user_id=).and_return(1)
                allow(@fake_comment).to receive(:save).and_return(true)
                cookies[:last_store]=2
                post :reply , params: {store_id:1,id:1,comment:@paramsi}
                expect(response).to redirect_to(store_path(2))
            end

               
                
        end

    end
    describe "edit" do
      before(:each) do
          allow(@fake_comment).to receive(:include?).with(1).and_return(true)
          allow(Comment).to receive(:find).with("1").and_return(@fake_comment)
      end

      it "prova" do
        allow(controller).to receive(:authorize!).and_return(true)
        get :edit ,params:{id: 1, store_id: 1}
        expect(response).to render_template(:edit)
      end
    end
    
    

    describe "indexreply" do
         before(:each) do
            allow(Comment).to receive(:new).and_return(@fake_comment)
           
           
            allow(@fake_comment).to receive(:user_id=).and_return(1)
            allow(@fake_comment).to receive(:store_id=).and_return(1)
            allow(@fake_comment).to receive(:comment_id=).and_return(1)
            allow(@fake_comment).to receive(:save).and_return(true)
            @fake_replies=double("Risp",replys:[double("comment1"),double("comment2")])
        end
        it "mostra risposte" do
            
            allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
            allow(controller).to receive(:authorize!).and_return("passed")
            
            allow(@fake_comment).to receive(:replys).and_return(@fake_replies)
            get :reply, params: {store_id:1,id:1,comment:{content:@fake_comment.content}}   
            expect(response).to redirect_to(store_path(1))


        end
    end

    describe "update" do
        before(:each) do
            
            allow(Comment).to receive(:find).with("1").and_return(@fake_comment)
            allow(@fake_comment).to receive(:include?).with(1).and_return(true)
        end
        it "modifica" do 
            allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
            allow(controller).to receive(:authorize!).and_return("passed")
            allow(@fake_comment).to receive(:update).and_return(@fake_comment)

            put :update, params: {store_id:1,id:1,comment:{content:"ciao"}}
            expect(response).to redirect_to(store_path(1))
        end
        
    end
    describe "destroy" do 
        before(:each) do
            
            allow(Comment).to receive(:find).with("1").and_return(@fake_comment)
            allow(@fake_comment).to receive(:include?).with(1).and_return(true)
        end
        it "elimina" do
            allow(controller).to receive(:current_user).and_return(@fake_user_comment1)
            allow(controller).to receive(:authorize!).and_return("passed")
            allow(@fake_comment).to receive(:destroy).and_return(true)
            delete :destroy, params: {store_id:1,id:1,comment:{content:@fake_comment.content}}
            
            
            expect(response).to redirect_to(store_path(1))
        end
    end
    #testiamo la variabile privata
    describe "comment" do
      it "il commento esiste" do
        allow(@fake_comment).to receive(:include?).with(1).and_return(true)
        allow(controller).to receive(:params).and_return({id: "1"})
        expect(Comment).to receive(:find)
        controller.send(:comment)
      end

      it "il commento non esiste" do
        allow(@fake_comment).to receive(:include?).with(1).and_return(false)
        allow(controller).to receive(:params).and_return({id: "1"})
        expect(controller).to receive(:redirect_to)
        controller.send(:comment)
      end
    end
end




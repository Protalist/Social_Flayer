require 'rails_helper'



RSpec.describe ProductsController, type: :controller do


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

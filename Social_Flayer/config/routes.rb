Rails.application.routes.draw do
  root 'users#home'
  get '/'=> 'users#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

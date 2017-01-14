Rails.application.routes.draw do
  root 'users#home'

  post 'home/change' => 'users#change', as: 'change'
  post 'home/back' => 'users#back', as: 'back'

  resources :stores do  #aggiungiamo routes per stores
	   member do
	      put 'like' => 'stores#upvote'
        put 'unlike' => 'stores#downvote'
      end
      resources :products, :except => [:index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

Rails.application.routes.draw do
  root 'users#home'



  scope :user do
    get "/:id"=>'users#show', as: 'user_show'
    post 'change' => 'users#change', as: 'change'
    post 'back' => 'users#back', as: 'back'
  end

  resources :stores do  #aggiungiamo routes per stores
	   member do
        post 'chooseyes'=>'stores#choose_yes'
        post 'follow'=>'stores#follow'
        post 'unfollow'=>'stores#unfollow'
        post 'chooseno'=>'stores#choose_no'
        post 'addadmin' => 'stores#addadmin'
	      put 'like' => 'stores#upvote'
        put 'unlike' => 'stores#downvote'
      end
      resources :products, :except => [:index]
      resources :comments do  #questo vuol dire che i commenti sono legati ai negozi
        resources :responds, :except => [:index]
         member do            #ora i member sono legati ai commenti
            post 'reply'=> 'comments#reply'
            get 'replyIndex' => 'comments#indexReply'
         end
      end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

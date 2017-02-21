Rails.application.routes.draw do
  root 'users#home'



  scope :user do
    get "/:id"=>'users#show', as: 'user'
    
    post 'change' => 'users#change', as: 'change'
    post 'back' => 'users#back', as: 'back'
    get "" => 'users#index', as: 'users'
    post '/:id/follow' => 'users#follow', as: 'follow_user'
    post '/:id/unfollow' => 'users#unfollow', as: 'unfollow_user'
  end

  get "/admin" => 'admins#homeadmin', as:'admin'
  resources :stores do  #aggiungiamo routes per stores
	   member do
        post 'chooseyes'=>'stores#choose_yes'
        post 'follow'=>'stores#follow'
        post 'unfollow'=>'stores#unfollow'
        post 'chooseno'=>'stores#choose_no'
        post 'addadmin' => 'stores#addadmin'
	      put 'like' => 'stores#upvote'
        put 'unlike' => 'stores#downvote'
        get 'leave' => 'stores#leave_store'
        post 'change_admin' => 'stores#change_admin'
      end
      resources :products, :except => [:index]

      resources :comments ,:except => [:show, :index] do  #questo vuol dire che i commenti sono legati ai negozi


        resources :responds, :except => [:index]
         member do            #ora i member sono legati ai commenti
            post 'reply'=> 'comments#reply'
            get 'replyIndex' => 'comments#indexReply'
         end
      end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get "*a" => "application#not_found"
end

Rails.application.routes.draw do
  root 'users#home'



  scope :user do
    get "/:id"=>'users#show', as: 'user'
    get "/:id/updatefollow" =>'users#updatefollow', as: 'upfollow'
    post 'change' => 'users#change', as: 'change'
    post 'back' => 'users#back', as: 'back'
    get "" => 'users#index', as: 'users'
    post '/:id/follow' => 'users#follow', as: 'follow_user'
    post '/:id/unfollow' => 'users#unfollow', as: 'unfollow_user'
    get "/:id/show_report" => 'admins#show_report', as: 'show_report_user'
    post "/:id/report" => 'admins#report', as: 'report_user'
  end

  get "/admin" => 'admins#homeadmin', as:'admin'
  get "/admin/ban/:id" => 'admins#show_ban', as: 'ban'
  post "/admin/ban/:id" => 'admins#send_ban', as: 'send_ban'
  resources :stores do  #aggiungiamo routes per stores
	   member do
       get 'picture/new' => "stores#new_photo", as: "new_photo"
        get 'picture/:picture_id' => "stores#show_photo", as: "show_photo"
        post 'picture/create' => "stores#create_photo", as: "create_photo"
        delete 'picture/:picture_id' => "stores#destroy_photo", as: "destroy_photo"

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

      resources :products, :except => [:index] do
        member do
          post 'follow'=>'products#follow'
          post 'unfollow'=>'products#unfollow'
        end
      end

      resources :comments ,:except => [:show, :index] do  #questo vuol dire che i commenti sono legati ai negozi


        resources :responds, :except => [:index]
         member do            #ora i member sono legati ai commenti
            post 'reply'=> 'comments#reply'
            get 'replyIndex' => 'comments#indexReply'
         end
      end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "sessions" }
  get "*a" => "application#not_found"
end

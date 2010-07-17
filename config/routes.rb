Pfc::Application.routes.draw do
  ## Dashboard

  root :to => 'dashboard#index'
  match 'dashboard' => redirect('/'), :as => :dashboard

  ## Login & Signup

  get  :login,  :to => 'sessions#new'
  post :login,  :to => 'sessions#create'
  get  :logout, :to => 'sessions#destroy'

  resource :session

  get  :signup, :to => 'users#new'
  post :signup, :to => 'users#create'

  ## Accounts, Transactions, Analytics, & Uploads

  resources :accounts do
    resources :transactions, :controller => 'txactions' do
      member do
        put :undelete
      end
    end

    collection do
      post :enable
      post :trigger_updates
    end

    member do
      get :financial_institution_site
    end
  end

  # TODO: Fix this hack.
  get '/transactions/rational(.:format)', :to => 'rational_txactions#index'

  resources :transactions, :controller => 'txactions' do
    member do
      put :undelete
      get :on_select_merchant
      get :transfer_selector
    end
  end

  resources :attachments
  resources :account_merchant_tag_stats
  resources :targets
  resources :trends
  resources :uploads do
    collection do
      match :choose
      get   :manual
    end
  end

  resources :merchants do
    collection do
      get :my,     :to => 'merchants#user_index'
      get :public, :to => 'merchants#public_index'
    end
  end

  resources :financial_insts, :path => 'financial-institutions'

  ## Member Data Snapshots

  resource  :snapshot

  ## Big Rock Candy Mountain Passthrough

  match '/data/transactions/*uri(.:format)',            :to => 'brcm#transactions'
  match '/data/investment-transactions/*uri(.:format)', :to => 'brcm#investment-transactions'
  match '/data/*uri(.:format)',                         :to => 'brcm#passthrough'

  ## User Profile & Preferences

  resource :profile
  resource :preferences, :controller => 'user_preferences'
  resource :user do
    get :change_password
    get :download_data
    get :delete_membership
  end

  ## Server-Side Uploader

  resources :credentials, :controller => 'account_creds' do
    resources :jobs, :controller => 'ssu_jobs'
  end

  ## Help & About

  get 'page/contribute', :as => :contribute, :to => 'page#contribute'
  get 'page/what',       :as => :what,       :to => 'page#what'
end
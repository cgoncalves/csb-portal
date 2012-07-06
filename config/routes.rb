CsbPortal::Application.routes.draw do
  match "/apps/step2" => "apps#step2"
  resources :apps do
	member do
	  get 'start'
	  get 'stop'
	  get 'restart'
      post 'scale/:instances', :action => 'scale'
    end
  end

  root :to => 'apps#index'
end

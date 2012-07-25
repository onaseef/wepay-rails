Rails.application.routes.draw do
  namespace :wepay do
    match 'ipn' => 'ipn#update'
    resources :authorize
    resources :checkout
  end
end

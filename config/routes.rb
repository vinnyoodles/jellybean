Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'question/create'
    end
  end
  get 'homepage/index'
  root 'homepage#index'
  get '/*path' => 'homepage#index'
end

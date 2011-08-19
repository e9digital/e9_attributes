Rails.application.routes.draw do
  base_path = 'admin'

  scope :path => base_path, :module => :e9_attributes do
    resources :menu_options, :except => [:show] do
      collection { post :update_order }
    end

    %w(
      menu_options
    ).each do |path|
      get "/#{path}/:id", :to => redirect("/#{base_path}/#{path}/%{id}/edit"), :constraints => { :id => /\d+/ }
    end
  end
end

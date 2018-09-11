Rails.application.routes.draw do
  resources :lists, except: %i[new edit] do
    resources :cards, except: %i[new edit] do
      resources :comments, except: %i[new edit]
    end
  end

  mount_devise_token_auth_for 'User', at: 'auth'
  post 'users/assign_user_to_list'
  post 'users/unassign_user_to_list'
end

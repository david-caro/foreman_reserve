Rails.application.routes.draw do

  namespace :api, :defaults => {:format => 'json'} do
    get 'hosts_reserve'          => 'v2/reserves#reserve'
    get 'hosts_release'          => 'v2/reserves#release'
    get 'show_available'         => 'v2/reserves#show_available'
    get 'show_reserved'          => 'v2/reserves#show_reserved'
    get 'update_reserved_reason' => 'v2/reserves#update_reason'

    scope "(:apiv)", :module => :v2,
                     :defaults => {:apiv => 'v2'},
                     :apiv => /v1|v2/,
                     :constraints => ApiConstraints.new(:version => 2) do

      resources :reserves, :only => [] do
        collection do
          get 'reserve'
          get 'release'
          get 'show_available'
          get 'show_reserved'
          get 'update_reserved_reason' => 'reserves#update_reason'
        end
      end
    end
  end

end

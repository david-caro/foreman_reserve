Rails.application.routes.draw do

  get "api/hosts_reserve"          => "api/v1/foreman_reserve#reserve"
  get "api/hosts_release"          => "api/v1/foreman_reserve#release"
  get "api/show_available"         => "api/v1/foreman_reserve#show_available"
  get "api/show_reserved"          => "api/v1/foreman_reserve#show_reserved"
  get "api/update_reserved_reason" => "api/v1/foreman_reserve#update_reason"

end

Rails.application.routes.draw do

  get "api/hosts_reserve"          => "reserve#reserve"
  get "api/hosts_release"          => "reserve#release"
  get "api/show_available"         => "reserve#show_available"
  get "api/show_reserved"          => "reserve#show_reserved"
  get "api/update_reserved_reason" => "reserve#update_reason"

end

require 'foreman_reserve'
require 'rails'
require 'action_controller'

module ForemanReserve
  class Engine < ::Rails::Engine

    config.to_prepare do
        Host::Managed.send :include, ForemanReserve::HostExtensions
        Host.send :include, ForemanReserve::HostExtensions
    end

  end
end

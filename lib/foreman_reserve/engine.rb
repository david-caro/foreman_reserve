module ForemanReserve
  class Engine < ::Rails::Engine

    config.to_prepare do
        ::Host.send :include, Host::HostExtensions
    end

    initializer 'foreman_reserve.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_reserve do
        requires_foreman '>= 1.4'

        security_block :foreman_reserve do
          permission :view_reserved_hosts, {:foreman_reserve => [:show_free, :show_reserved]}
          permission :reserve_and_free_hosts, {:foreman_reserve => [:reserve, :release, :update_reason]}
        end

        role "Reserve Hosts", [:view_reserved_hosts, :reserve_and_free_hosts]
      end
    end

  end
end

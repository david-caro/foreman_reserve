module ForemanReserve
  class Engine < ::Rails::Engine

    config.to_prepare do
      if SETTINGS[:version].to_s.to_f >= 1.2
        # Foreman 1.2
        Host::Managed.send :include, Host::HostExtensions
      else
        # Foreman < 1.2
        Host.send :include, Host::HostExtensions
      end
    end

    initializer 'foreman_reserve.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_reserve do
        requires_foreman '>= 1.4'

        security_block :foreman_reserve do
          permission :view_reserved_hosts,    { 'api/v2/reserves' => [:show_available, :show_reserved] }
          permission :reserve_and_free_hosts, { 'api/v2/reserves' => [:reserve, :release, :update_reason] }
        end

        role "Reserve Hosts", [:view_reserved_hosts, :reserve_and_free_hosts]
      end
    end

  end
end

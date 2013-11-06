module ForemanReserve
  module HostExtensions
    extend ActiveSupport::Concern
      module InstanceMethods
        def reserve!(reason = 'true')
          param = "RESERVED"
            if p=host_parameters.find_by_name(param)
            p.update_attribute(:value, reason)
          else
            host_parameters.create!(:name => param, :value => reason)
          end
        end
        def release!
          param = "RESERVED"
          if p=host_parameters.find_by_name(param)
            p.update_attribute(:value, "false")
          end
        end
        def as_json(options={})
          super(:methods => [:host_parameters])
      end
    end
  end
end

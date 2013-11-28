module ForemanReserve
  module HostExtensions
    extend ActiveSupport::Concern
    module InstanceMethods

      # Reserve the host
      #
      # @param reason [String] Reason to reserve the host under
      def reserve!(reason = 'true')
        param = "RESERVED"
        if p=host_parameters.find_by_name(param)
          p.update_attribute(:value, reason)
        else
          host_parameters.create!(:name => param, :value => reason)
        end
      end

      # Release the host
      def release!
        param = "RESERVED"
        if p=host_parameters.find_by_name(param)
          p.update_attribute(:value, "false")
        end
      end

      # Return a json represenatation of the host
      def as_json(options={})
        super(:methods => [:host_parameters])
      end

    end
  end
end

module Api
  module V1
    class ForemanReserveController < Api::V1::BaseController
      unloadable

    def get_reserved(query='')
      hosts = User.current.admin? ? Host::Managed : Host::Managed.my_hosts
      hosts.search_for(query)
      hosts.each do |host|
        params = host.info()['parameters']
        if params and
            params.key?('RESERVED') and 
            params['RESERVED'] != 'false'
          host
        end
      end
    end

    def get_free(query='')
      hosts = User.current.admin? ? Host::Managed : Host::Managed.my_hosts
      hosts.search_for(query)
      hosts.each do |host|
        params = host.info()['parameters']
        if params
            and params.has_key('RESERVED')
            and params['RESERVED'] == 'false'
          host
        end
      end
    end

    def not_found(exception = nil)
        logger.debug "not found: #{exception}" if exception
        respond_to do |format|
            format.html { render "common/404", :status => 404 }
            format.json { head :status => 404}
            format.yaml { head :status => 404}
        end 
        true
    end 

    def reserve
      amount          = (params[:amount] || 1).to_i
      reason          = params[:reason] || 'true'
      ## Lock to avoid reserving the same host twice
      unless File.exists? "/tmp/foreman_reserve.lock"
        File.open("/tmp/foreman_reserve.lock", 'w') {}
      end 
      lock = File.new("/tmp/foreman_reserve.lock")
      begin
        lock.flock(File::LOCK_EX)
        potential_hosts = get_free(params[:query])
        return not_found if potential_hosts.empty?
        return not_acceptable if potential_hosts.count < amount
        @hosts = potential_hosts[0..(amount-1)].each do |host|
          logger.error host.class.name
          logger.error host.class.instance_methods(false)
          logger.error Host.class.instance_methods(false)
          host.reserve!(reason)
        end
      ensure
        lock.flock(File::LOCK_UN)
      end
      respond_to do |format|
        format.json {render :json => @hosts }
        format.yaml {render :text => @hosts.to_yaml}
        format.html {not_found }
      end
    end

    def release
      host_name     = (params[:host_name] || '')
      query         = params[:query]
      amount        = (params[:amount] || 0 ).to_i
      if host_name != ''
        query = "#{query} AND name = #{host_name}"
      end
      reserved_hosts = get_reserved(query)
      return not_found if reserved_hosts.empty?
      if amount != 0
        return not_acceptable if reserved_hosts.count < amount
        @hosts = reserved_hosts[0..(amount-1)].each { |host| host.release! }
      else
        @hosts = reserved_hosts.each { |host| host.release! }
      end
      respond_to do |format|
        format.json {render :json => @hosts.map(&:name) }
        format.yaml {render :text => @hosts.to_yaml}
        format.html {not_found }
      end
    end

    def show_reserved
      hosts = get_reserved(params[:query])
      return not_found if hosts.empty?
      respond_to do |format|
        format.json {render :json => hosts }
        format.yaml {render :text => hosts.to_yaml}
        format.html {not_found }
      end
    end

      def show_available
        amount = (params[:amount] || 0).to_i
        hosts  = get_free(params[:query])
        return not_found if hosts.empty?
        if amount != 0
          return not_acceptable if hosts.count < amount
          hosts = hosts[0..(amount-1)]
        end
        respond_to do |format|
          format.json {render :json => hosts }
          format.yaml {render :text => hosts.to_yaml}
          format.html {not_found }
        end
      end

      def update_reason
        amount          = (params[:amount] || 0).to_i
        reason          = params[:reason] || 'true'
        potential_hosts = get_reserved(params[:query])
        return not_found if potential_hosts.empty?
        if amount != 0
          return not_acceptable if potential_hosts.count < amount
          potential_hosts[0..(amount-1)].each { |host| host.reserve!(reason) }
        else
          potential_hosts.each { |host| host.reserve!(reason) }
        end
        @hosts = get_reserved(params[:query])
        respond_to do |format|
          format.json {render :json => @hosts }
          format.yaml {render :text => @hosts.to_yaml}
          format.html {not_found }
        end
      end

      def not_acceptable
        head :status => 406
      end

    end
  end
end

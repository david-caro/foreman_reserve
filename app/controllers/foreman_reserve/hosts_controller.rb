module ForemanReserve
  class HostsController < ::HostsController

    unloadable


    def get_reserved(query='')
        hosts = User.current.admin? ? Host : Host.my_hosts
        hosts.search_for(query).includes(:host_parameters).where("parameters.name = ?", "RESERVED").where("managed = ?", "true").where("parameters.value !~ ?", "false")
    end

    def get_free(query='')
        hosts = User.current.admin? ? Host : Host.my_hosts
        hosts.search_for(query).includes(:host_parameters).where("parameters.name = ?", "RESERVED").where("managed = ?", "true").where("parameters.value ~ ?", "false")
    end

    def reserve
      unless api_request?
        error "This operation is only valid via an API request"
        #"TODO redirect_back_or_to(main_app.root_path) "
        redirect_to('/')  and return
      end
      amount          = (params[:amount] || 1).to_i
      reason          = params[:reason] || 'true'
      potential_hosts = get_free(params[:query])
      return not_found if potential_hosts.empty?
      return not_acceptable if potential_hosts.count < amount
      @hosts = potential_hosts[0..(amount-1)].each { |host| host.reserve!(reason) }
      respond_to do |format|
        format.json {render :json => @hosts }
        format.yaml {render :text => @hosts.to_yaml}
        format.html {not_found }
      end
    end

    def release
      unless api_request?
        error "This operation is only valid via an API request"
        #"TODO redirect_back_or_to(main_app.root_path) "
        redirect_to('/')  and return
      end
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
      unless api_request?
        error "This operation is only valid via an API request"
        #"TODO redirect_back_or_to(main_app.root_path) "
        redirect_to('/')  and return
      end
      hosts = get_reserved(params[:query])
      return not_found if hosts.empty?
      respond_to do |format|
        format.json {render :json => hosts }
        format.yaml {render :text => hosts.to_yaml}
        format.html {not_found }
      end
    end

    def show_available
      unless api_request?
        error "This operation is only valid via an API request"
        #"TODO redirect_back_or_to(main_app.root_path) "
        redirect_to('/')  and return
      end
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
      unless api_request?
        error "This operation is only valid via an API request"
        #"TODO redirect_back_or_to(main_app.root_path) "
        redirect_to('/')  and return
      end
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

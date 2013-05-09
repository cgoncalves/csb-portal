class Dashboard::AppsController < DashboardController
  before_filter :authenticate_user!

  # GET /apps
  # GET /apps.json
  def index
    @apps = @client.apps

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
    @app = @client.app(params[:id])
    @paas_providers = cached_providers

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @repository_types = [ ['Git', 'git'], ['SVN', 'svn'] ]

    if (params[:manifest])
      @id = params[:id]
      @manifest = {}
      @manifest['rules'] = []
      params[:manifest].each do |r|
        r[1].each do |v|
          @manifest['rules'].push( {:name => r[0], :params => [v]} ) unless v.empty?
        end
      end

      #unless (params[:manifest][:runtime].all?(&:blank?) || params[:manifest][:framework].all?(&:blank?))
      @providers = @client.eval_manifest(@manifest)
      unless @providers.empty?
        @frameworks = @client.providers_frameworks(@providers)
        @services = @client.providers_service_vendors(@providers)
        @metrics = @client.providers_metrics(@providers)
      else
        @runtimes = @client.providers_runtimes(cached_providers)
        @frameworks = @client.providers_frameworks(cached_providers)
        @services = @client.providers_service_vendors(cached_providers)
        @metrics = @client.providers_metrics(cached_providers)
      end
    else
      @runtimes = @client.providers_runtimes(cached_providers)
      @frameworks = @client.providers_frameworks(cached_providers)
      @services = @client.providers_service_vendors(cached_providers)
      @metrics = @client.providers_metrics(cached_providers)
    end

    @rules = []
    @rules.push({id: 'service', name: 'Service'})
    @rules.push({id: 'monitoring', name: 'Monitoring'})

    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
      #format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = @client.app(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    manifest = JSON.parse(params[:manifest])
    manifest['provider'] = params[:provider]
    @client.app_create(params[:id], params[:repository_type])
    @client.app_add_manifest(params[:id], manifest)

    respond_to do |format|
      format.html { redirect_to app_path(params[:id]), notice: 'App was successfully created.' }
      #if @client.app_create(params[:id], manifest)
      #  format.html { redirect_to app_path(params[:id]), notice: 'App was successfully created.' }
      #  #  FIXME format.json { render json: @app, status: :created, location: app_path(params[:id]) } 
      #else
      #  format.html { render action: "new" }
      #  format.json { render json: @app.errors, status: :unprocessable_entity } # FIXME
      #end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @app = @client.app(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app]) # FIXME
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @client.app_destory(params[:id])

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :no_content }
    end
  end

  def start
    @start = @client.app_start(params[:id])

    respond_to do |format|
      format.js # start.js.erb
    end
  end

  def stop
    @stop = @client.app_stop(params[:id])

    respond_to do |format|
      format.js # stop.js.erb
    end
  end

  def log
    @log = @client.app_log(params[:id])

    respond_to do |format|
      format.html { render partial: 'log' }
      format.json { render json: @log }
    end
  end

  def monitor
    samples = 100;
    samples = params[:samples] unless params[:samples].nil?
    @monitor = @client.app_monitor(params[:id], samples)

    respond_to do |format|
      format.html { render partial: 'monitor' }
      format.json { render json: @monitor }
    end
  end

  def scale
    @client.app_scale(params[:id], params[:instances])

    respond_to do |format|
      format.html { redirect_to app_path(params[:id]), notice: "App was successfully scaled to #{params[:instances]} instances." }
    end
  end

  def migrate
    paas_provider = params[:paas_provider].pop
    @client.app_migrate(params[:id], paas_provider)

    respond_to do |format|
      format.html { render partial: 'migrate' }
      format.html { redirect_to app_path(params[:id]), notice: "App was successfully migrated to #{paas_provider.humanize}." }
    end
  end

end

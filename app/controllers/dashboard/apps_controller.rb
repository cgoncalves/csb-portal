require 'paas_providers'
require 'manifest'

class Dashboard::AppsController < DashboardController
  # GET /apps
  # GET /apps.json
  def index
    @apps = App.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
    @app = App.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @app = App.new

    if (params[:manifest])
      @id = params[:id]
      @manifest = Manifest.new
      @manifest[:rules] = []
      params[:manifest].each do |r|
        r[1].each do |v|
          @manifest[:rules].push( {:name => r[0], :params => [v]} ) unless v.empty?
        end
      end

      unless (params[:manifest][:runtime].all?(&:blank?) || params[:manifest][:framework].all?(&:blank?))
        @providers = App.eval_manifest(@manifest)
        @runtimes = PaasProviders.runtimes(providers: @providers)
        @frameworks = PaasProviders.frameworks(providers: @providers)
        @services = PaasProviders.services(providers: @providers)
        @metrics = PaasProviders.metrics(providers: @providers)
      else
        @providers = []
      end
    else
      @runtimes = PaasProviders.runtimes(:all)
      @frameworks = PaasProviders.frameworks
      @services = PaasProviders.services(:all)
      @metrics = PaasProviders.metrics(:all)
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
    @app = App.find(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(params[:id])
    @app.manifest = Manifest.new(JSON.parse(params[:manifest]))
    @app.manifest.provider = params[:provider]

    respond_to do |format|
      if @app.save
        format.html { redirect_to app_path(@app.id), notice: 'App was successfully created.' }
        format.json { render json: @app, status: :created, location: @app }
      else
        format.html { render action: "new" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
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
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :no_content }
    end
  end

  def log
    #@app = App.find(params[:id])
    @log = App.log(params[:id])

    respond_to do |format|
      format.html { render partial: 'log' }
      format.json { render json: @log }
    end
  end

  def report
  end

  def start
    @start = App.start(params[:id])

    respond_to do |format|
      format.js # start.js.erb
    end
  end

  def stop
    @stop = App.stop(params[:id])

    respond_to do |format|
      format.js # stop.js.erb
    end
  end
end

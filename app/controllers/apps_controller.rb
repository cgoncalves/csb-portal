require 'json'
require 'paasproviders'

class AppsController < ApplicationController
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
    @app_info = @app.info

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @app = App.new
    @runtimes = PaasProviders.runtimes
    @frameworks = PaasProviders.frameworks
    @services = PaasProviders.services

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new( {:name => params[:app][:appId]} )

    manifest = JSON.parse(params[:app][:manifest])
    manifest['provider'] = params[:app][:provider]

    respond_to do |format|
      if @app.save(Manifest.new(manifest))
        format.html { redirect_to app_path(@app.name), notice: 'App was successfully created.' }
        format.json { render json: @app, status: :created, location: @app }
      else
        format.html { render action: "new" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /apps/1/step2
  def step2
    @app = App.new(params[:app])

    @manifest = Manifest.new
    @manifest.runtime = JSON.parse(params['manifest']['runtime'])
    @manifest.framework = JSON.parse(params["manifest"]['framework'])

    unless params['services'].nil?
      params['services'].each do |s|
        @manifest.services << JSON.parse(s)
      end
      puts @manifest.services.class
      puts @manifest.services
    end

    @providers = @manifest.score
    #not necessary anymore @providers = @providers['paasProviders']

    puts @providers
    puts "PAAS PROVIDERS:"
    @providers.each do |p|
      puts p['services']
    end

    respond_to do |format|
      format.html # new.html.erb
      #format.html { render action: "step2" }
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

  def start
    @app = App.find(params[:id])
    @app.start

    respond_to do |format|
      format.html { redirect_to app_path(@app.name), notice: 'App was successfully started.' }
      format.json { render json: @app, status: :started, location: @app }
    end
  end

  def stop
    @app = App.find(params[:id])
    @app.stop

    respond_to do |format|
      format.html { redirect_to app_path(@app.name), notice: 'App was successfully stopped.' }
      format.json { render json: @app, status: :stopped, location: @app }
    end
  end

  def restart
    @app = App.find(params[:id])
    @app.restart

    respond_to do |format|
      format.html { redirect_to app_path(@app.name), notice: 'App was successfully restarted.' }
      format.json { render json: @app, status: :restarted, location: @app }
    end
  end

  def scale
    @app = App.find(params[:id])
    @app.scale(params[:instances])

    respond_to do |format|
      format.html { redirect_to app_path(@app.name), notice: "App was successfully scaled to #{params[:instances]}." }
      format.json { render json: @app, status: :scaled, location: @app }
    end    
  end

  def add_service
  end

  def delete_service
  end

end

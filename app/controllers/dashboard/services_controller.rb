class Dashboard::ServicesController < DashboardController
  layout false

  # GET /services
  # GET /services.json
  def index
    @services = @client.services(params[:app_id])
    @app = @client.app(params[:app_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @services }
    end
  end

  # GET /services/1
  # GET /services/1.json
  def show
    @service = @client.service(params[:id], params[:app_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/new
  # GET /services/new.json
  def new
    @service = {}
    @app = @client.app(params[:app_id])

    @services = {}
    if @app['provider']
      provider = cached_provider(@app['provider']['id'])
      @services = provider['service_vendors']
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service }
    end
  end

  # GET /services/1/edit
  def edit
    @service = @client.service(params[:id], params[:app_id])
    @app = @client.app(params[:app_id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @service }
    end

  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(params[:id])
    @service.app_id = params[:app_id]
    @service['vendor_id'] = params[:vendor_id].pop

    respond_to do |format|
      if @service.save
        format.html { redirect_to app_service_path(@service.app_id, @service.id), notice: 'Service was successfully created.' }
        format.json { render json: @service, status: :created, location: @service }
      else
        format.html { render action: "new" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.json
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    #@service = Service.find(params[:id])
    @service = Service.new
    @service.id = params[:id]
    @service.app_id = params[:app_id]
    @service.destroy

    respond_to do |format|
      format.html { redirect_to app_services_url }
      format.json { head :no_content }
    end
  end
end

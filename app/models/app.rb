require 'csbmodel'
require 'errorresponse'
require 'applicationcreateresponse'
require 'applicationdeployresponse'
require 'applicationstartresponse'
require 'applicationstopresponse'
require 'applicationrestartresponse'
require 'applicationdeleteresponse'
require 'applicationstatusresponse'
require 'applicationinforesponse'
require 'applicationlogsresponse'

class App < CsbModel
  attr_accessor :id, :name, :url, :provider, :status, :repository, :instances

  def initialize(attributes={})
	super(attributes)
  end

  def self.find(name)
	r = CsbModel.conn.get "/csb/rest/apps/#{name}.json"
	return App.new(r.body)
  end

  def self.all
	r = CsbModel.conn.get "/csb/rest/apps.json"
	raise "#{r.status}: Something went wrong!" unless r.success?
	apps = Array.new
	r.body['apps'].each do |app|
	  apps << App.new(app)
	end
	apps
  end

  def save(manifest)
	r = CsbModel.conn.post do |req|
	  req.url "/csb/rest/apps/#{name}.json"
	  req.headers['Content-Type'] = 'application/json'
	  req.body = manifest.to_json
	end
	unless r.success?
	  errors.add(:name, ErrorResponse.new(r.body).message)
	  return false
	end
	#raise "#{r.status}: Something went wrong!" unless r.success?
	response = ApplicationCreateResponse.new(r.body)
	@url = response.appUrl
	true
  end

  def deploy
	r = CsbModel.conn.put "/csb/rest/apps/#{name}/deploy.json"
	raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
	ApplicationDeployResponse.new(r.body)
  end

  def start
	r = CsbModel.conn.put "/csb/rest/apps/#{name}/start.json"
	raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
	ApplicationStartResponse.new(r.body)
  end

  def stop
	r = CsbModel.conn.put "/csb/rest/apps/#{name}/stop.json"
	raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
	ApplicationStopResponse.new(r.body)
  end

  def restart
	r = CsbModel.conn.put "/csb/rest/apps/#{name}/restart.json"
	raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
	ApplicationRestartResponse.new(r.body)
  end

  def destroy
	r = CsbModel.conn.delete "/csb/rest/apps/#{name}.json"
	raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
	ApplicationDeleteResponse.new(r.body)
  end

  #def statusApp
  #  r = CsbModel.conn.get "/csb/rest/apps/#{name}/status.json"
  #  raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
  #  ApplicationStatusResponse.new(r.body)
  #end

  #def log
  #  r = CsbModel.conn.get "/csb/rest/apps/#{name}/log.json"
  #  raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
  #  raise "#{r.status}: Something went wrong!" unless r.success?
  #  ACMLog.new(r.body)
  #end

  def scale(instances)
    r = CsbModel.conn.post "/csb/rest/apps/#{name}/scale/#{instances}.json"
    raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    ApplicationScaleResponse.new(r.body)
  end

  def info
    r = CsbModel.conn.get "/csb/rest/apps/#{name}/info.json"
    raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    ApplicationInfoResponse.new(r.body)
  end

  def log
    r = CsbModel.conn.get "/csb/rest/apps/#{name}/log.json"
    raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    ApplicationLogsResponse.new(r.body)
  end

end


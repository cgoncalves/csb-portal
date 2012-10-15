require 'csbmodel'

class App < CsbModel

  validates_presence_of :id, :message => "can't be blank"

  def self.find(id)
    r = CsbModel.conn.get "/csb/rest/apps/#{id}.json"
    App.new(r.body)
  end

  def self.all
    r = CsbModel.conn.get "/csb/rest/apps.json"
    raise "#{r.status}: Something went wrong!" unless r.success?
    r.body.collect! {|app| App.new(app)}
  end

  def self.eval_manifest(manifest)
    r = CsbModel.conn.post do |req|
      req.url '/csb/rest/manifest.json'
      req.headers['Content-Type'] = 'application/json'
      req.body = manifest.to_json
    end
    raise "#{r.status}: Something went wrong!" unless r.success?
    r.body
  end

  def self.start(id)
    r = CsbModel.conn.put "/csb/rest/apps/#{id}/start.json"
    r.success?
  end

  def self.stop(id)
    r = CsbModel.conn.put "/csb/rest/apps/#{id}/stop.json"
    r.success?
  end

  def self.restart(id)
    r = CsbModel.conn.put "/csb/rest/apps/#{id}/restart.json"
    r.success?
  end

  def self.log(id)
    r = CsbModel.conn.get "/csb/rest/apps/#{id}/log.json"
    Log.new(r.body)
  end

  def self.scale(id, instances)
    r = CsbModel.conn.put "/csb/rest/apps/#{id}/scale/#{instances}"
    r.success?
  end

  def self.monitor(id, samples=10)
    r = CsbModel.conn.get "/csb/rest/apps/#{id}/monitor.json?samples=#{samples}"
    AppMonitor.new(r.body)
  end

  def self.migrate(id, paas_provider)
    r = CsbModel.conn.put "/csb/rest/apps/#{id}/migrate/#{paas_provider}.json"
    r.success?
  end

  def start
    self.class.start(id)
  end

  def stop
    self.class.stop(id)
  end

  def restart
    self.class.restart(id)
  end

  def log
    self.class.log(id)
  end

  def scale(instances)
    self.class.scale(id, instances)
  end

  def monitor(samples=10)
    self.class.monitor(id, samples)
  end

  def migrate(paas_provider)
    self.class.migrate(id, paas_provider)
  end

  def save
    r = CsbModel.conn.post do |req|
      req.url "/csb/rest/apps/#{id}.json"
      req.headers['Content-Type'] = 'application/json'
      req.body = manifest.to_json
    end
    r.success?
  end

  def destroy
    r = CsbModel.conn.delete "/csb/rest/apps/#{id}.json"
    #raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    r.success?
  end

  def scale(instances)
    r = CsbModel.conn.post "/csb/rest/apps/#{id}/scale/#{instances}.json"
    #raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    r.success?
  end

  def info
    r = CsbModel.conn.get "/csb/rest/apps/#{id}/info.json"
    #raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    r.success?
  end

end

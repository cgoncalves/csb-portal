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

  def self.monitor(id)
    r = CsbModel.conn.get "/csb/rest/apps/#{id}/monitor.json"
    AppMonitor.new(r.body)
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

  def monitor
    self.class.monitor(id)
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

require 'csbmodel'

class Service < CsbModel

  validates_presence_of :id, :message => "can't be blank"

  def self.find(id, app_id)
    r = CsbModel.conn.get "/csb/rest/apps/#{app_id}/services/#{id}.json"
    Service.new(r.body)
  end

  def self.all(app_id)
    r = CsbModel.conn.get "/csb/rest/apps/#{app_id}/services.json"
    raise "#{r.status}: Something went wrong!" unless r.success?
    r.body.collect! {|service| Service.new(service)}
  end

  def save
    puts "--------------------------------------------------------"
    puts "Appid: #{app_id}, service id: #{id}, vendor_id: #{vendor_id}"
    puts "--------------------------------------------------------"
    r = CsbModel.conn.post do |req|
      req.url "/csb/rest/apps/#{app_id}/services/#{id}/#{vendor_id}.json"
      req.headers['Content-Type'] = 'application/json'
    end
    r.success?
  end

  def destroy
    r = CsbModel.conn.delete "/csb/rest/apps/#{app_id}/services/#{id}.json"
    #raise "#{r.status}: #{ErrorResponse.new(r.body).message}" unless r.success?
    r.success?
  end

end

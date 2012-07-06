require 'csbmodel'

class Manifest < CsbModel
  attr_accessor :provider, :runtime, :framework, :services

  def initialize(attributes={})
    super(attributes)
    @runtime = Hash.new if @runtime.nil?
    @framework = Hash.new if @framework.nil?
    @services = Array.new if @services.nil?
  end

  def score
    r = CsbModel.conn.post do |req|
      req.url '/csb/rest/manifest.json'
      req.headers['Content-Type'] = 'application/json'
      req.body = self.to_json
    end
    raise "#{r.status}: Something went wrong!" unless r.success?
    r.body['paasProviders'] # array of paas providers
  end

  def attributes
    { 'provider' => provider, 'runtime' => runtime, 'framework' => framework, 'services' => services }
  end

end


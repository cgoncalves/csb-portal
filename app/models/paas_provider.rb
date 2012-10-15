require 'csbmodel'

class PaasProvider < CsbModel
  @@providers = nil

  def self.find(id)
    all.each do |p|
      return p if p.id.eql? id
    end
  end

  def self.all
    if @@providers.nil?
      r = CsbModel.conn.get "/csb/rest/paas/offerings.json"
      raise "#{r.status}: Something went wrong!" unless r.success?
      @@providers = r.body.collect! {|provider| PaasProvider.new(provider)}
    end
    @@providers
  end

  def self.runtimes(providers = nil)
    self.generic_feature('runtimes', providers)
  end

  def self.frameworks(providers = nil)
    self.generic_feature('frameworks', providers)
    #self.generic_feature('frameworks', providers).map! {|f|
    #  Framework.new(f)
    #}
  end

  def self.service_vendors(providers = nil)
    self.generic_feature('service_vendors', providers)
  end

  def self.metrics(providers = nil)
    self.generic_feature('metrics', providers)
  end

  def self.generic_feature(name, providers = nil)
    providers = self.all if providers.nil?

    generic = []
    providers.each do |p|
      generic |= p[name]
    end
    generic
  end
end


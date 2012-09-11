require 'csbmodel'

class PaasProviders < CsbModel
  @@providers = nil

  def self.offerings
    if @@providers.nil?
      r = CsbModel.conn.get "/csb/rest/paas/offerings.json"
      raise "#{r.status}: Something went wrong!" unless r.success?
      @@providers = r.body
    end
    @@providers
  end

  def self.runtimes(*args)
    self.generic_feature('runtimes', *args)
  end

  def self.frameworks(*args)
    self.generic_feature('frameworks', *args)
  end

  def self.services(*args)
    self.generic_feature('services', *args)
  end

  def self.metrics(*args)
    self.generic_feature('monitoringMetrics', *args)
  end

  def self.generic_feature(name, *args)
    unless args.first.nil?
      case args.first
      when :all
        providers = self.offerings
      when :providers
        options = args.extract_options!
        providers = options[:providers]
      else
      providers = self.offerings
      end
    else
      providers = self.offerings
    end

    generic = []
    providers.each do |p|
      generic |= p[name]
    end
    generic
  end
end


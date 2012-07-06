require 'csbmodel'
require 'paasprovider'

class PaasProviders < CsbModel
  attr_accessor :paasProviders

  def initialize(attributes={})
	super(attributes)
  end

  def self.offerings
	r = CsbModel.conn.get "/csb/rest/paas/offerings.json"
	raise "#{r.status}: Something went wrong!" unless r.success?
	providers = Array.new
	r.body['paasProviders'].each do |p|
	  providers << PaasProvider.new(p)
	end
	providers
  end

  def self.runtimes
	runtimes = Array.new
	self.offerings.each do |p|
	  runtimes |= p.runtimes
	end
	runtimes
  end

  def self.frameworks
	frameworks = Array.new
	self.offerings.each do |p|
	  frameworks |= p.frameworks
	end
	frameworks
  end

  def self.services
	services = Array.new
	self.offerings.each do |p|
	  services |= p.services
	end
	services
  end
end


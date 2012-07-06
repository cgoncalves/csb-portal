require 'csbmodel'

class ManifestResponse < CsbModel
  attr_accessor :paasProviders

  def initialize(attributes={})
	super(attributes)
	@paasProviders = Array.new if @services.nil?
  end

end


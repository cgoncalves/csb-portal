require 'csbmodel'

class PaasProvider < CsbModel
  attr_accessor :name, :score, :runtimes, :frameworks, :services

  def initialize(attributes={})
	super(attributes)
  end
end


class ApplicationInfoResponse < CsbModel
  attr_accessor :paasProvider, :appID, :appStatus, :appUrl, :appMemory, :appInstances, :appStack, :appServicesId

  def initialize(attributes={})
	super(attributes)
  end
end


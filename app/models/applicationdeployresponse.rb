class ApplicationDeployResponse < CsbModel
  attr_accessor :paasProvider, :appID, :appStatus, :appUrl

  def initialize(attributes={})
	super(attributes)
  end
end


class ApplicationLogsResponse < CsbModel
  attr_accessor :paasProvider, :appID, :appLog, :appUrl

  def initialize(attributes={})
	super(attributes)
  end
end


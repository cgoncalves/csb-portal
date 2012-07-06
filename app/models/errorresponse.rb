class ErrorResponse < CsbModel
  attr_accessor :code, :message

  def initialize(attributes={})
	super(attributes)
  end
end

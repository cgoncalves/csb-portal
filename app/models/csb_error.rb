class CsbError
  extend ActiveModel::Naming

  attr_reader :errors

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def CsbError.human_attribute_name(attr, options = {})
    attr
  end

  def CsbError.lookup_ancestors
    [self]
  end
end

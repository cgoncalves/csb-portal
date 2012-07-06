require 'json'

class CsbModel
  include Csb

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Serializers::JSON

  attr_reader :errors

  def initialize(attributes={})
	attributes.each do |name, value|
	  send("#{name}=", value)
    end
	@errors = ActiveModel::Errors.new(self)
  end

  def self.conn
	Csb::connection
  end

  def as_json(options={})
	 self.attributes.to_json(options)
     #options[:except] ||= [:errors]
     #super(options)
  end

  def to_json(options={})
	 self.attributes.to_json(options)
     #options[:except] ||= [:errors]
     #super(options)
  end

  #def to_hash
  #  hash = {}
  #  self.instance_variables.each do |var|
  #    hash[var.slice(1..-1)] = self.instance_variable_get var
  #  end
  #  hash
  #end

  #def to_json
  #  to_hash.to_json
  #end

  #def from_json! string
  #  JSON.load(string).each do |var, val|
  #    self.instance_variable_set var, val
  #  end
  #end

  def persisted?
    false
  end
end


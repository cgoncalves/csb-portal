class CsbModel < Hashie::Mash
  include ActiveModel::Validations

  def self.conn
    Csb::connection
  end

  def initialize(*args)
    (args.size == 1 && args[0].class != Hash) ? super(id: args[0]) : super(*args)
  end

  def to_param
    id
  end

  def attributes
    keys
  end
end


require 'csbmodel'

class Service < CsbModel

  validates_presence_of :id, :message => "can't be blank"

  def self.find(id)
  end

  def self.all
  end

  def save
  end

end

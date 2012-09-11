require 'csbmodel'

class Manifest < CsbModel
  validates_presence_of :id
end

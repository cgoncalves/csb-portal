module Csb
  @conn = Faraday.new(:url => 'http://fog.av.it.pt:8080') do |builder|
	builder.use Faraday::Request::UrlEncoded
	builder.use Faraday::Adapter::NetHttp
	builder.use FaradayMiddleware::ParseJson
  end

  def self.connection
	@conn
  end

end


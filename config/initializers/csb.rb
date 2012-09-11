module Csb
  @conn = Faraday.new(:url => 'http://localhost:8080') do |builder|
    builder.response :logger
	builder.use Faraday::Request::UrlEncoded
	builder.use Faraday::Adapter::NetHttp
    #builder.use Faraday::Response::Mashify
	builder.use FaradayMiddleware::ParseJson
  end

  def self.connection
	@conn
  end

end


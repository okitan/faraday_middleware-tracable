require "faraday"
require "faraday_middleware"

module FaradayMiddleware
  require "faraday_middleware/tracable/request/tracable"

  ::Faraday::Request.register_middleware(
    tracable: -> { ::FaradayMiddleware::Tracable }
  )
end

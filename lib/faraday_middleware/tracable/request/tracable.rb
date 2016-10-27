module FaradayMiddleware
  class Tracable < ::Faraday::Middleware
    # You need to specify
    # type as symbol
    #   or
    # header_name: and block or header_value:
    def initialize(app, type_or_options, &block)
      if type_or_options.is_a?(Hash)
        @header_name  = type_or_options[:header_name]
        @header_value = block || type_or_options[:header_value]
      elsif type_map.has_key?(type_or_options)
        @header_name  = type_map[type_or_options][:header_name]
        @header_value = type_map[type_or_options][:header_value]
      end

      super(app)
    end

    def call(env)
      if @header_name && @header_value
        env[:request_headers][@header_name] = @header_value.is_a?(Proc) ? instance_eval(&@header_value) : @header_value
      end
      @app.call(env)
    end

    def type_map
      {
        stackdriver: {
          header_name: "X-Cloud-Trace-Context",
          header_value: ->(_) {
            trace_id = SecureRandom.hex(32)

            "#{trace_id}/0;o=1"
          }
        },
      }
    end
  end
end

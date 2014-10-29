module Glider
  module Messaging
    class Publisher

      def initialize(options = {})
        set_options options
        establish_connection
      end

      def publish_to_queue(queue_name, payload)
        log "[#{queue_name}] publishing (#{payload.class.name}) #{payload.inspect}"
        @exchange.publish payload.to_yaml,
                         routing_key:  queue_name,
                         content_type: 'application/x-yaml'
      end

      protected

      def set_options(options)
        @options = {
          exchange_type: :topic,
          exchange_name: 'messaging',
          debugging:     true,
        }.update(options)
      end

      def connection
        Source.instance.connection
      end

      def establish_connection
        @channel  = connection.create_channel
        @exchange = @channel.send @options[:exchange_type], @options[:exchange_name]
      end

      def log(msg)
        return unless @options[:debugging]
        Utils.log :publisher, msg
      end

    end
  end
end
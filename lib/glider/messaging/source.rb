require 'bunny'
require 'singleton'

module Glider
  module Messaging
    class Source

      include Singleton

      attr_reader :connection

      def initialize(conn_string = 'amqp://0.0.0.0:5672', options = {})
        set_options options
        establish_connection conn_string
        at_exit { @connection.close }
      end

      protected

      def set_options(options)
        @options = {
          debugging: true,
        }.update(options)
      end

      def establish_connection(conn_string)
        @connection = ::Bunny.new(conn_string).tap{ |c| c.start }
      end

      def log(msg)
        return unless @options[:debugging]
        Utils.log :publisher, msg
      end

    end
  end
end
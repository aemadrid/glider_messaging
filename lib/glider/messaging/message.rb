require 'yaml'
require 'json'

module Glider
  module Messaging
    class Message

      attr_reader :delivery_info, :metadata, :payload, :content_type

      def initialize(delivery_info, properties, body)
        @delivery_info = delivery_info
        @metadata      = properties
        @content_type  = properties.content_type
        @payload       = parse_body body
      end

      protected

      def parse_body(body)
        case content_type
          when 'application/x-yaml'
            YAML.load body
          when /json/i
            JSON.parse body
          else
            body.to_s
        end
      end

    end
  end


end
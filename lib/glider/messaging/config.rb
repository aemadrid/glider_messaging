module Glider
  module Messaging
    class Config

      def self.options
        @options ||= {

        }
      end

      def self.log(sender, msg)
        puts "[#{sender}] #{msg}"
      end

    end
  end
end
begin
  require 'terminfo'
  TERM_INFO_LOADED = true
rescue LoadError
  # No console info
  TERM_INFO_LOADED = false
end


module Glider
  module Messaging
    class Utils

      def self.cls
        system 'clear'
      end

      def self.hdr(sender)
        "[#{sender}] "
      end

      def self.log(sender, msg)
        puts "[#{sender}] #{msg}"
      end

      def self.banner(sender, msg, liner = '=')
        header = hdr(sender)
        width = Utils.screen_size.last - header.size
        puts header + " [ #{msg} ] ".center(width, '=')
      end

      def self.screen_size
        if Object.const_defined?(:TermInfo)
          ::TermInfo.screen_size
        else
          [25, 80]
        end
      end

    end
  end
end


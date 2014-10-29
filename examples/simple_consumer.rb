#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../lib/glider_messaging'
include Glider::Messaging

class MessageProcessor
  def perform(message)
    Utils.log :message_processor, "Received (#{message.payload.class.name}) #{message.payload.inspect}"
    true
  end
end

if __FILE__ == $0
  Utils.cls
  consumer = Consumer.new 'ex1', MessageProcessor
  trap('INT') { consumer.cancel; consumer.connection.close; exit }
  sleep
end

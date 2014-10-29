#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../lib/glider_messaging'
include Glider::Messaging

class MessageProducer

  def initialize(queue_name, publisher, qty = 1)
    @queue_name = queue_name
    @qty = qty
    @publisher = publisher
  end

  def random_message
    "#{%w{ you I he }.sample} " +
      "should be #{%w{ cooking writing speaking }.sample} " +
      "for #{['the president', 'your boss', 'your mother'].sample}"
  end

  def publisher
    Celluloid::Actor[:publisher]
  end

  def run
    log 'No qty provided for messages to send ...' unless @qty > 0

    log "Starting to publish #{@qty} random messages to [#{@queue_name}] ..."
    @cnt = 0
    while @cnt < @qty
      msg = random_message
      log "[#{@cnt + 1}/#{@qty}] Sending [#{msg}]"
      @publisher.publish_to_queue @queue_name, msg
      @cnt += 1
    end
    log "Finished publishing #{@qty} random messages to [#{@queue_name}] ..."
  end

  def log(msg)
    Utils.log :producer, msg
  end

end

if __FILE__ == $0
  Utils.cls
  qty = ENV.fetch('QTY', ARGV[0] || 10).to_i
  publisher = Publisher.new
  producer = MessageProducer.new 'ex1', publisher, qty
  producer.run
end

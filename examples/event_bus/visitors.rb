#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../../lib/glider_messaging'
require 'faker'
include Glider::Messaging

class VisitorProducer

  def initialize(queue_name, publisher, qty = 1)
    @queue_name = queue_name
    @qty = qty
    @publisher = publisher
  end

  def random_visitor
    {
      full_name: Faker::Name.name,
      amount: [30.75, 50.25, 100.01].sample,
    }
  end

  def run
    log 'No qty provided for visitors to send ...' unless @qty > 0

    log "Starting to publish #{@qty} random visitors to [#{@queue_name}] ..."
    @cnt = 0
    while @cnt < @qty
      msg = random_visitor
      log "[#{@cnt + 1}/#{@qty}] Sending [#{msg.inspect}]"
      @publisher.publish_to_queue @queue_name, msg
      @cnt += 1
    end
    log "Finished publishing #{@qty} random visitors to [#{@queue_name}] ..."
  end

  def log(msg)
    Utils.log :producer, msg
  end

end

if __FILE__ == $0
  Utils.cls
  qty = ENV.fetch('QTY', ARGV[0] || 10).to_i
  publisher = Publisher.new
  producer = VisitorProducer.new 'ticket.sale', publisher, qty
  producer.run
end

#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../../lib/glider_messaging'
include Glider::Messaging

class TicketOffice
  def perform(message)
    ticket = message.payload
    Utils.log :ticket_office, "One more visitor, baby! #{ticket[:full_name]}"
    true
  end
end

if __FILE__ == $0
  Utils.cls
  consumer = Consumer.new 'ticket.office', TicketOffice, routing_keys: %w{ ticket.sale }
  trap('INT') { consumer.cancel; exit }
  sleep
end

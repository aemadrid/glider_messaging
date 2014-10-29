#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../../lib/glider_messaging'
include Glider::Messaging

class AccountingOffice
  def perform(message)
    ticket = message.payload
    Utils.log :ticket_office, "Give me the money, baby! $#{ticket[:amount]}"
    true
  end
end

if __FILE__ == $0
  Utils.cls
  consumer = Consumer.new 'accounting.office', AccountingOffice, routing_keys: %w{ ticket.sale }
  trap('INT') { consumer.cancel; exit }
  sleep
end

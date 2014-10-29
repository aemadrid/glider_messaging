module Glider
  module Messaging
    class Consumer

      attr_reader :channel, :queue

      def initialize(queue_name, processor_class, options = {}, &blk)
        @queue_name = queue_name
        @klass      = processor_class
        @blk        = blk

        set_options options
        establish_connection
        run
      end

      def run
        log "Receiving messages for [#{@queue_name}] to [#{@klass.name}] ..."
        @subscriber = @queue.subscribe(manual_ack: true) do |delivery_info, properties, body|
          handle_message delivery_info, properties, body
        end
      end

      def cancel
        return unless @subscriber
        @subscriber.cancel
        log "Not receiving messages for [#{@queue_name}] to [#{@klass.name}] anymore ..."
      end

      def connection
        Source.instance.connection
      end

      protected

      def set_options(options)
        @options = {
          exchange_type: :topic,
          exchange_name: 'messaging',
          routing_keys:  [@queue_name],
          queue_options: {durable: true, auto_delete: false, exclusive: false},
          prefetch:      1,
          debugging:     true,
        }.update(options)
      end

      def establish_connection
        @channel  = connection.create_channel.tap { |c| c.prefetch @options[:prefetch] }
        @exchange = @channel.send @options[:exchange_type], @options[:exchange_name]
        @queue    = @channel.queue @queue_name, @options[:queue_options]
        @options[:routing_keys].each { |key| @queue.bind(@exchange, routing_key: key) }
      end

      def handle_message(delivery_info, properties, body)
        banner 'Received message'
        debug :delivery_info, delivery_info, nil
        debug :properties, properties
        debug :body, body
        message = Message.new delivery_info, properties, body
        if @blk
          result = @blk.call message
        else
          result = @klass.new.perform message
        end
        debug :result, result
        @channel.ack delivery_info.delivery_tag
      rescue Exception => e
        log_exception e
      end

      def log(msg)
        return unless @options[:debugging]
        Utils.log :consumer, msg
      end

      def banner(msg)
        return unless @options[:debugging]
        Utils.banner :consumer, msg
      end

      def debug(name, obj, meth = :inspect)
        log "#{name} : (#{obj.class.name}) #{meth.nil? ? '-' : obj.send(meth)}"
      end

      def log_exception(e)
        log "Exception: #{e.class.name} : #{e.message}\n  #{e.backtrace[0, 5].join("\n  ")}"
      end

    end
  end
end
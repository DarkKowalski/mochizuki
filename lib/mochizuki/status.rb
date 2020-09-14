# frozen_string_literal: true

module Mochizuki
  module Status
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def status
        @status ||= Status.new
      end

      def reset_status
        @status = Status.new
      end

      def update_status(power)
        last = Mochizuki.status.below_threshold
        current = power.to_f < @config.alarm_threshold.to_f
        @logger.info "Status, @below_threshold, last: #{last}, current: #{current}"

        Mochizuki.status.below_threshold = current

        return unless !current && last # re-enabled auto alarm

        Mochizuki.status.alarmed_before = false
        @logger.info "Status, @alarmed_before, #{@alarmed_before}, auto alarm enabled"
      end
    end

    class Status
      attr_accessor :below_threshold, :alarmed_before

      def initialize(logger = Mochizuki.logger)
        @logger = logger
        @below_threshold = nil
        @alarmed_before = false
      end

      def auto_alarm_enabled?
        if @below_threshold.nil?
          @logger.error "Unable to check status, @below_threshold can't be nil"
          raise Mochizuki::Error, 'Invalid @below_threshold'
        end

        @below_threshold && !@alarmed_before
      end
    end
  end
end

module Mochizuki
  include Status
end

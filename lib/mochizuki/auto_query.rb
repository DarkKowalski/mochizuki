# frozen_string_literal: true

require 'rufus-scheduler'

module Mochizuki
  class AutoQuery
    def initialize(logger = Mochizuki.logger, config = Mochizuki.config)
      @logger = logger
      @config = config

      Mochizuki::Fetcher.new.fetch # update Mochizuki.status
    end

    def alarm
      scheduler = Rufus::Scheduler.new
      scheduler.every @config.query_interval.to_s do
        power = Mochizuki::Fetcher.new.fetch
        @logger.info "Auto query, #{power} kWh remaining"
        if Mochizuki.status.auto_alarm_triggered?
          yield(power)
          Mochizuki.status.alarmed_before = true
          @logger.info 'Auto alarm is suppressed for now'
        end
      end
    end
  end
end

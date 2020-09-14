# frozen_string_literal: true

module Mochizuki
  module Configurable
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def config
        @config ||= Configuration.new
      end

      def reset_config
        @config = Configuration.new
      end

      def configure
        yield(config)
      end
    end

    class Configuration
      attr_accessor :bot_token, :channel,
                    :api_host, :api_port,
                    :query_interval, :alarm_threshold,
                    :campus, :building, :floor, :dorm

      def initialize
        @bot_token = nil
        @channel = nil

        @api_host = '202.120.163.129' # https://nyglzx.tongji.edu.cn
        @api_port = '88'

        @query_interval = '300s'
        @alarm_threshold = '60' # kWh

        # shitty names from legacy code
        @campus = nil   # -> drlouming
        @building = nil # -> drceng
        @floor = nil    # -> dr_ceng
        @dorm = nil     # -> drfangjian
      end
    end
  end
end

module Mochizuki
  include Mochizuki::Configurable
end

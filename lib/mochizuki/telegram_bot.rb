# frozen_string_literal: true

require 'telegram/bot'

module Mochizuki
  class Bot
    def initialize(logger = Mochizuki.logger, config = Mochizuki.config)
      @config = config
      @logger = logger
    end

    def start
      Telegram::Bot::Client.run(@config.bot_token) do |bot|
        Mochizuki::AutoQuery.new.alarm do |power|
          bot.api.send_message(chat_id: @config.channel,
                               text: "Dorm: #{@config.dorm}: #{power} kWh, " \
                               "lower than threshold #{@config.alarm_threshold} kWh")
        end
        @logger.info 'Auto query enabled'

        bot.listen do |msg|
          @logger.info "ID: #{msg.chat.id} uses #{msg}"
          case msg.text
          when '/start'
            send_msg = 'I am a telegram bot written in ruby, '\
                       'details at https://github.com/DarkKowalski/mochizuki'
            bot.api.send_message(chat_id: msg.chat.id,
                                 text: send_msg)
          when '/query'
            dorm = @config.dorm
            begin
              power = Mochizuki::Fetcher.new.fetch
              send_msg = "Dorm #{dorm}: #{power} kWh"
            rescue StandardError
              send_msg = 'Failed to query.'
            end
            bot.api.send_message(chat_id: msg.chat.id, text: send_msg)
          when '/status'
            send_msg = "Bot status: auto alarm is suppressed -> #{Mochizuki.status.alarmed_before}"
            bot.api.send_message(chat_id: msg.chat.id, text: send_msg)
          else
            @logger.warn "Unknown command #{msg}"
            bot.api.send_message(chat_id: msg.chat.id, text: "Use '/query' to get remaining power")
          end
        end
      end
    end
  end
end

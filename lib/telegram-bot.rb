require 'rubygems'
require 'telegram/bot'
require 'rufus-scheduler'
require_relative './fetcher'
require_relative './timer'

$token = ENV['tg_bot_token'].to_s
$post_data = ENV['tg_bot_post_data'].to_s
$threshold = ENV['tg_bot_threshold'].to_i
$channel = ENV['tg_bot_channel'].to_s
$admin = ENV['tg_bot_admin'].to_s
$frequency = ENV['tg_bot_frequency'].to_s

$timer_enable = true
$low_power = false

fetcher = Fetcher.new($post_data)

Telegram::Bot::Client.run($token) do |bot|

  scheduler = Rufus::Scheduler.new
  scheduler.every "#{$frequency}" do
    if $timer_enable
      balance = timer
      if $low_power
        bot.api.send_message(chat_id: "@#{$channel}", text: "Warning! Remaining balance: #{balance}. Current threshold: #{$threshold}. Timer off, restart manually /timer_on")
      end
    end
  end

  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}, Mochizuki here. I am a telegram bot written in ruby, details at https://github.com/DarkKowalski/mochizuki-bot")
    when '/info'
      if $timer_enable
        timer_status = "on"
      else
        timer_status = "off"
      end
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}, Mochizuki here, timer is #{timer_status}, use /query to get current balance. ")
    
    when '/timer_off'
      if message.chat.username.downcase == "#{$admin}".downcase
        $timer_enable = false
        bot.api.send_message(chat_id: message.chat.id, text: "Okay, timer got disabled.")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Only admin can do this, current admin is @#{$admin}.")
      end
    
    when '/timer_on'
      if message.chat.username.downcase == "#{$admin}".downcase
        $timer_enable = true
        bot.api.send_message(chat_id: message.chat.id, text: "Good, turn on timer.")
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Only admin can do this, current admin is #{$admin}.")
      end
    
    when '/query'
      begin
        fetcher.fetch
        dorm = fetcher.get_dorm
        balance = fetcher.get_balance
        target_message = "your dorm: #{dorm}, balance: #{balance}"
      rescue 
        target_message = "somthing went wrong, try again later."
      end
      bot.api.send_message(chat_id: message.chat.id, text: "Hi, #{message.from.first_name}, #{target_message}")

    else
      bot.api.send_message(chat_id: message.chat.id, text: "(´～`)? Mochizuki got confused. Use /query to get current balance.")
    end
  end
end

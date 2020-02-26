require 'telegram/bot'
require_relative './fetcher'

def timer
  fetcher = Fetcher.new($post_data)
  begin
    fetcher.fetch
    dorm = fetcher.get_dorm
    balance = fetcher.get_balance
  rescue 
    dorm = -1
    balance = -1
  end

  if dorm.to_i > 0 && balance.to_i < $threshold.to_i
    $low_power = true
    $timer_enable = false
  else
    $low_power = false
  end

  balance
end

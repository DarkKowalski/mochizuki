# frozen_string_literal: true

require 'test_helper'

class ConfigurableTest < Minitest::Test
  def teardown
    Mochizuki.reset_config
  end

  def test_load_config
    load 'test/unit/mochizuki.conf'
    assert(Mochizuki.config.bot_token == 'bot_token')
  end
end

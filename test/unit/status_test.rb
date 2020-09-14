# frozen_string_literal: true

require 'test_helper'

class StatusTest < Minitest::Test
  def setup
    @status = Mochizuki.status
  end

  def teardown
    Mochizuki.reset_status
  end

  def test_valid_auto_alarm_enabled
    @status.below_threshold = true
    @status.alarmed_before = false
    result = @status.auto_alarm_enabled?
    assert(result == true)
  end

  def test_invalid_auto_alarm_enabled
    assert_raises(Mochizuki::Error) { @status.auto_alarm_enabled? }
  end
end

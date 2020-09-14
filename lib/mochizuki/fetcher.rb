# frozen_string_literal: true

require 'faraday'
require 'uri'
require 'nokogiri'

module Mochizuki
  class Fetcher
    def initialize(logger = Mochizuki.logger, config = Mochizuki.config)
      @logger = logger
      @config = config

      @uri = URI("http://#{@config.api_host}:#{config.api_port}")

      @request_body = {
        '__EVENTTARGET' => '',
        '__EVENTARGUMENT' => '',
        '__LASTFOCUS' => '',
        '__VIEWSTATE' => '',
        '__VIEWSTATEGENERATOR' => 'CA0B0334',
        'drlouming' => '',
        'drceng' => '',
        'dr_ceng' => '',
        'drfangjian' => '',
        'radio' => 'usedR',
        'ImageButton1.x' => '0',
        'ImageButton1.y' => '0'
      }

      @cookie = nil
    end

    def fetch
      fetch_viewstate
      fetch_cookie
      power = fetch_power

      if power.nil?
        @logger.warn 'Failed to query.'
        return
      end

      Mochizuki.update_status(power)
      power
    end

    private

    def fetch_viewstate
      @request_body['drlouming'] = @config.campus
      @request_body['drceng'] = @config.building
      @request_body['dr_ceng'] = @config.floor
      @request_body['drfangjian'] = @config.dorm

      3.times do
        resp = Faraday.post(@uri) do |req|
          req.headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
          req.body = URI.encode_www_form(@request_body)
        end
        html = Nokogiri::HTML(resp.body)
        @request_body['__VIEWSTATE'] = html.at_css('input#__VIEWSTATE')['value']
      end
    end

    def fetch_cookie
      resp = Faraday.post(@uri) do |req|
        req.headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
        req.body = URI.encode_www_form(@request_body)
      end
      @cookie = resp.headers['set-cookie'].split('; ')[0]
    end

    def fetch_power
      resp = Faraday.get("#{@uri}/usedRecord1.aspx") do |req|
        req.headers = { 'Cookie' => @cookie, 'Content-Type' => 'application/x-www-form-urlencoded' }
      end
      html = Nokogiri::HTML(resp.body)
      html.xpath('//h6').text.scan(/(\d+[,.]\d+)/)[0][0]
    end
  end
end

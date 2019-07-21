require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'nokogiri'

class Fetcher
  def initialize(post_data)
    @uri = URI('http://202.120.163.129:88')
    @http = Net::HTTP.new(@uri.hostname, @uri.port)

    @post_path = "/default.aspx"
    @post_data = post_data
    @post_header = {'Content-Type' => 'application/x-www-form-urlencoded'}

    @get_path = "/usedRecord1.aspx"
  end

  def fetch_cookie
    @post_result = @http.post(@post_path, @post_data, @post_header)
    @cookie = @post_result.response['set-cookie'].split('; ')[0]
  end

  def fetch_raw_data
    @get_header = {
      'Cookie' => @cookie,
      'Content-Type' => 'application/x-www-form-urlencoded'
    }

    @get_result = @http.get(@get_path,@get_header)
    @raw_data = @get_result.body
  end

  def parse_data
    @parsed_data = Nokogiri::HTML(@raw_data)
    @target_data = @parsed_data.xpath("//h6").text
  end

  def fetch
    self.fetch_cookie
    self.fetch_raw_data
    self.parse_data
  end

  def get_dorm
    @dorm = @target_data.to_s.scan(/\d+/)[0]
    return @dorm
  end

  def get_balance
    @balance = @target_data.to_s.scan(/(\d+[,.]\d+)/)[0][0]
    return @balance
  end
end
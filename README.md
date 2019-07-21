# Mochizuki bot
[同济大学能源管理中心电费查询](http://202.120.163.129:88/)

This bot can automatically query remaining balance and send warning message to channel when it's not enough.

More about [Telegram Bot](https://core.telegram.org/bots)
# Usage

Docker image

```bash
docker pull darkkowalski/mochizuki-bot:latest
```

Config and run

```bash
docker run -d \
        --restart=always \
        # telegram bot token from @BotFather
        -e tg_bot_token="114514" \
        # Raw form data
        -e tg_bot_post_data="1919" \
        # send warning when balance gets below threshold
        -e tg_bot_threshold="810" \
        # channel for warning messages
        -e tg_bot_channel="SenpaChannel" \
        # only admin can operate schedule
        -e tg_bot_admin="Tadokoro" \
        # optional proxy
        #-e http_proxy="http://proxy.example.com:1919"
        #-e https_proxy="http://proxy.example.com:1919"
        --name="mochizuki-bot" \
        -it darkkowalski/mochizuki-bot:latest 
```

**Notice**: use the channel username and admin username **without** "@" symbol

## Proxy

Usually we can not access [同济大学能源管理中心电费查询](http://202.120.163.129:88/) behind proxy, while we can not access telegram API without proxy or VPN.

Workaround: set up a proxy bypass filter, **Privoxy** supports this.

## Post Data

[同济大学能源管理中心电费查询](http://202.120.163.129:88/)

This website uses pervious version of **APS.NET**.

Mochizuki will auto handle Session ID, but you should config post data manually to indicate which dorm you would like to set.

Go to the website and fill that form.

The post data you need is contained in `/defualt.aspx`, pass it as raw data string to ENV.

It's in the form of something like
```
__EVENTTARGET=dr_ceng&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=%2FwEPDwULLTE0MTgxMTM1NTAPZBYCAgEPZBYIAgEPEGRkFgECAWQCAw8QDxYGHg1EYXRhVGV4dEZpZWxkBQhST09NTkFNRR4ORGF0YVZhbHVlRmllbGQFBnJvb21kbR4LXyFEYXRhQm91bmRnZBAVHQbmpbzmoIsP6KW%2F5Y2X5LiA5Y%2B35qW8D%2Bilv%2BWMl%2BS6jOWPt%2BalvAnlrabkuInmpbwJ5a2m5Zub5qW8CeWtpuS6lOalvA3opb%2FljZc35Y%2B35qW8Deilv%2BWNlzjlj7fmpbwN6KW%2F5Y2XOeWPt%2BalvA%2Fopb%2FljZfljYHlj7fmpbwS6KW%2F5Y2X5Y2B5LiA5Y%2B35qW8Euilv%2BWNl%2BWNgeS6jOWPt%2BalvA%2Fopb%2FljJfkuIDlj7fmpbwP6KW%2F5Y2X5LqM5Y%2B35qW8D%2Bilv%2BWNl%2BS4ieWPt%2BalvAnpnZLlubTmpbwJ6Kej5pS%2B5qW8FeWNl%2BagoeWMuuWQjuWLpOWFrOWvkxLmnKzpg6jlkI7li6Tlhazlr5MQ5Y2a5aOr55SfM%2BWPt%2BalvA3opb%2FljJcz5Y%2B35qW8Deilv%2BWMlzTlj7fmpbwN6KW%2F5YyXNeWPt%2BalvBDljZrlo6vnlJ805Y%2B35qW8EOeVmeWtpueUnzHlj7fmpbwQ55WZ5a2m55SfMuWPt%2BalvBDljZrlo6vnlJ815Y%2B35qW8DOihjOaUv%2BWNl%2BalvAzooYzmlL%2FljJfmpbwVHQACMDECMDICMDMCMDQCMDUCMDcCMDgCMDkCMTACMTECMTICMjECMjICMjMCMjQCMjUCMjYCMjcCMzACMzMCMzQCMzUCNDACNDECNDICNTACNjYCNzcUKwMdZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2dnZ2cWAQIBZAIFDxAPFgYfAAUIUk9PTU5BTUUfAQUGcm9vbWRtHwJnZBAVCQbmpbzlsYIV6KW%2F5Y2X5LiA5Y%2B35qW85YWs55SoE%2Bilv%2BWNl%2BS4gOWPt%2BalvDTlsYIY6KW%2F5Y2X5LiA5Y%2B35qW8MTAwMS0xMDk5GOilv%2BWNl%2BS4gOWPt%2BalvDExMDAtMTE5ORjopb%2FljZfkuIDlj7fmpbwyMDAxLTIwOTkY6KW%2F5Y2X5LiA5Y%2B35qW8MjEwMC0yMTk5GOilv%2BWNl%2BS4gOWPt%2BalvDMwMDAtMzA5ORjopb%2FljZfkuIDlj7fmpbwzMTAwLTMxOTkVCQAEMDEwMAQwMTA0BDAxMTAEMDExMQQwMTIwBDAxMjEEMDEzMAQwMTMxFCsDCWdnZ2dnZ2dnZxYBZmQCBw8QZBAVAQbmiL%2Fpl7QVAQAUKwMBZ2RkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYEBQRidXlSBQV1c2VkUgUMSW1hZ2VCdXR0b24xBQxJbWFnZUJ1dHRvbjKpCuGb%2B6mO0M%2FnLKJPjyZJ2rPNLBHMQCThNmSGJpjk6w%3D%3D&__VIEWSTATEGENERATOR=CA0B0334&drlouming=2&drceng=01&dr_ceng=0110&drfangjian=
```

# Website API
Firstly post to fetch Session ID, then get with Session ID.

## Post

### Request

```
URI        http://202.120.163.129:88
Path       /default.aspx
Header     Content-Type: application/x-www-form-urlencoded
Form       //mentioned before
```

### Response

```
Session ID
```

## Get

### Request
```
URI        http://202.120.163.129:88
Path       /usedRecord1.aspx
Header     Content-Type: application/x-www-form-urlencoded
Cookie     Session ID
```
### Response
```
HTML file
```

# Thanks
[atipugin/telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) Usable API wrapper

[sparklemotion/nokogiri](https://github.com/sparklemotion/nokogiri) Powerful HTML, XML, SAX, and Reader parser

[jmettraux/rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) Scheduled background task

[Ruby China Gem mirror](https://gems.ruby-china.com/) Good as usual
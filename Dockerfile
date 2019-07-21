FROM ruby:2.6

RUN mkdir /usr/src/app
ADD . /usr/src/app
WORKDIR /usr/src/app

ENV tg_bot_token tg_bot_threshold tg_bot_post_data tg_bot_channel tg_bot_admin http_proxy https_proxy
RUN bundle install

CMD ruby /usr/src/app/lib/telegram-bot.rb
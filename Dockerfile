FROM ruby:2.7.1-buster
WORKDIR /build

COPY . .

RUN bundle config set without 'development rubocop' && \
    bundle && \
    gem build && \
    gem install --local mochizuki-*.gem

RUN rm -rf /build

WORKDIR /app
COPY ./entrypoint.sh .
ENTRYPOINT [ "./entrypoint.sh" ]

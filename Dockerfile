FROM ruby:2.5.9

RUN apt-get update -qq && \
  apt-get install -y build-essential \
  nodejs \
  vim \
  mariadb-client \
  imagemagick

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler && \
  bundle install && \
  mkdir -p tmp/sockets && \
  mkdir -p tmp/pids

COPY . /app
RUN rm -rf /usr/local/bundle/cache/* /app/vendor/bundle/cache/*

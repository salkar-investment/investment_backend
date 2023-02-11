# syntax=docker/dockerfile:1
FROM ruby:3.2.1

RUN apt-get update -qq && apt-get install lsb-release -y
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -qq && apt-get install postgresql-client-15 -y

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install

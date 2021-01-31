FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
WORKDIR /init_tracker

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

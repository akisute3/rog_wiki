FROM ruby:2.3.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install -j4 --without development test

COPY . /usr/src/app

EXPOSE 3000
CMD ["bundle", "exec", "unicorn", "-E", "production", "-c", "config/unicorn.rb"]

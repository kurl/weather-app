FROM ruby:2.6.3-alpine3.9

WORKDIR /work/app

RUN gem install bundler
RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install  --without development

COPY . .

CMD ["./main"]


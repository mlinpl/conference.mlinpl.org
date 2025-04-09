FROM ruby:3.0.2-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    nodejs \
    npm \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./

RUN gem install bundler
RUN bundle config set --local path 'vendor/bundle'
RUN bundle config set --local force_ruby_platform true
RUN bundle install

COPY . .

EXPOSE 4000

RUN chown -R 1000:1000 /app

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload"]
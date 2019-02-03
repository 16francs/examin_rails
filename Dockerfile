FROM ruby:2.6.0

ENV LANG C.UTF-8
ENV PROJECT=examin_rails

RUN apt-get update -qq
RUN apt-get install -y \
      build-essential \
      mysql-client \
      nodejs \
      vim

WORKDIR /$PROJECT

# Copy Gemfile
COPY Gemfile* ./

# Bundle Install
RUN gem install bundler
RUN bundle install --path vendor/bundle --without production

# Copy Project
ADD . ./

EXPOSE 3000

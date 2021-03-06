FROM ruby:2.6.0

ENV LANG C.UTF-8
ENV PROJECT=examin_rails

RUN apt-get update -qq
RUN apt-get install -y \
      build-essential \
      mysql-client \
      nodejs \
      tzdata \
      vim

# Set Timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

WORKDIR /$PROJECT

# Copy Gemfile
COPY Gemfile* ./

# Bundle Install
RUN gem install bundler
RUN bundle install --without production

# Copy Project
ADD . ./

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-e", "development", "-p", "3000", "-b", "0.0.0.0"]

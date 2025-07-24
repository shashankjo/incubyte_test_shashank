FROM ruby:3.3-alpine as base

RUN apk update && apk upgrade && apk --no-cache add \
    tzdata \
    bash \
    git \
    build-base \
    libstdc++ \
    ca-certificates \
    ruby-dev \
    curl \
    libffi-dev \
    postgresql-dev \
    linux-headers \
    libpq \
    openssh \
    file \
    && echo ‘gem: --no-document’ > /etc/gemrc && \
    find / -type f -iname \*.apk-new -delete && \
    rm -rf /var/cache/apk/* && \
    echo "CACHED:$(date +'%Y%G')"

RUN mkdir -p /app/vendor/gems
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

ARG GITHUB_TOKEN
ARG GITHUB_USERNAME
RUN bundle config https://rubygems.pkg.github.com/acima-credit $GITHUB_USERNAME:$GITHUB_TOKEN

ENV BUNDLER_VER 2.3.26
RUN gem install bundler:$BUNDLER_VER

ADD . /app
WORKDIR /app
COPY *.env *.yaml /config/

RUN bundle config set --local without 'development test'
RUN bundle config set --local deployment 'true'
RUN bundle install --full-index

RUN rm -rf /usr/lib/lib/ruby/gems/*/cache/*
RUN rm -rf ~/.gem

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]

# Deploy Image
FROM base as deploy
COPY --from=base /app /app

# CI Image
FROM base as ci

COPY --from=base /app /app

RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ../cc-test-reporter
RUN chmod +x ../cc-test-reporter

RUN bundle config set --local without 'development'
RUN bundle config set --local deployment 'true'
RUN bundle install --full-index

# Dev Image
# This was injected by the acima/container_tools gem without regard
# to restructuring the Dockerfile. You should review your docker file
# ensuring this adjustment is properly added.
FROM base as dev

COPY --from=base /app /app

RUN bundle config unset --local without
RUN bundle config set --local deployment 'true'
RUN bundle install --full-index


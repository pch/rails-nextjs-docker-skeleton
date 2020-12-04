ARG RUBY_VERSION=2.6.6
FROM ruby:$RUBY_VERSION

ARG PG_MAJOR=12
ARG NODE_MAJOR=12
ARG BUNDLER_VERSION=2.1.4
ARG RAILS_ENV=production

# Install essential packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  gnupg2 \
  build-essential \
  curl \
  less \
  git \
  lsb-release \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list (client only)
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Install application dependencies
# (Application-specific packages should be declared in ./docker/Aptfile)
COPY ./docker/Aptfile /tmp/Aptfile
RUN apt-get update && apt-get install -y --no-install-recommends \
  libpq-dev \
  postgresql-client-$PG_MAJOR \
  $(cat /tmp/Aptfile | grep -v -s -e '^#' -e '^$' | xargs) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV RAILS_ROOT /usr/src/app
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY ./Gemfile* $RAILS_ROOT/

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=10 \
  BUNDLE_RETRY=3 \
  BUNDLE_PATH=/gems

# Upgrade RubyGems and install required Bundler version
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

RUN bundle install

ENV PATH /usr/src/app/bin:$PATH

COPY . /usr/src/app/

ENTRYPOINT ["./docker/docker-entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]

#!/bin/sh
set -e

bundle exec rake db:create

exec "$@"

#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive
export CI=true
export TRAVIS=true
export CONTINUOUS_INTEGRATION=true
export USER=travis
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RAILS_ENV=test
export RACK_ENV=test
export MERB_ENV=test
export JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"

apt-get update && apt-get install -y tzdata postgresql-client libpq-dev

gem install bundler -v 2.0.1

export TRAVIS_BUILD_DIR=$PWD

bundle install --without nothing
bundle exec rake db:migrate
bundle exec rake test:coverage

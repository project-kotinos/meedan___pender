#!/bin/bash
bundle exec rake db:create
bundle exec rake db:migrate
export SECRET_KEY_BASE=$(bundle exec rake secret)
bundle exec rake lapis:api_keys:create_default

# Sidekiq
$"bin/sidekiq" &

mkdir -p /app/tmp/pids
rm -f /app/tmp/pids/server-$RAILS_ENV.pid
if [ "$RAILS_ENV" == "test" ]
then
  rm -rf /app/public/cache/test/*
  rm -rf /app/tmp/cache/*
  bundle exec rails s -b 0.0.0.0 -p $SERVER_PORT -P /app/tmp/pids/server-$RAILS_ENV.pid
else
  puma="/app/tmp/puma-$RAILS_ENV.rb"
  cp config/puma.rb $puma
  echo "pidfile '/app/tmp/pids/server-$RAILS_ENV.pid'" >> $puma
  echo "port $SERVER_PORT" >> $puma
  bundle exec puma -C $puma
fi

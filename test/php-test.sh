#!/bin/bash

set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

expect << EOF
  spawn $dir/fetch-repo-launcher.sh https://github.com/slotbox/php-hello-world.git
  expect "PHP app detected"
  expect "Bundling Apache version"
  expect "Bundling PHP version"
  expect "Discovering process types"
  expect "Default process types for PHP -> web"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

if [ "$(ls -A /app)" ]
then
  echo "/app directory not empty, might be something important, quitting".
  exit 1
fi

rm -rf /app
sudo mkdir -p /app
sudo chmod 777 /app
mv /tmp/checkout/* /app
cd /app

cat >> .env << EOF
PATH=bin:$PATH
PORT=9999
EOF

foreman start &
pid=$!
sleep 5

expect << EOF
  spawn curl localhost:9999
  expect "I have 2 foo"
  expect eof
EOF

kill -2 $pid
killall httpd

rm -rf /app
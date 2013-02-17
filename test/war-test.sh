#!/bin/bash

set -e

export PATH=bin:$PATH

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

expect << EOF
  set timeout 30
  spawn $dir/fetch-repo-launcher.sh https://github.com/heroku/devcenter-webapp-runner.git
  expect "Java app detected"
  expect "BUILD SUCCESS"
  expect "Discovering process types"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

echo "java.runtime.version=1.7" > /tmp/checkout/system.properties
cd /tmp/checkout
cat >> .env << EOF
PATH=bin:.jdk/bin:$PATH
PORT=9999
EOF

foreman start &
pid=$!
sleep 5

expect << EOF
  spawn curl localhost:9999
  expect "Hello World!"
  expect eof
EOF

kill -2 $pid

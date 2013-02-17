#!/bin/bash

set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# `set timeout -1' prevents deployment bailing during `bundle install` sub process
expect << EOF
  set timeout -1
  spawn $dir/fetch-repo-launcher.sh https://github.com/slotbox/ruby-hello-world.git
  expect "Ruby app detected"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

cd /tmp/checkout
cat >> .env << EOF
PATH=bin:$PATH
GEM_HOME=/tmp/cache/vendor/bundle/ruby/1.9.1/
PORT=9999
EOF

foreman start &
pid=$!
sleep 5

expect << EOF
  spawn curl localhost:9999
  expect "Hello, world"
  expect eof
EOF

kill -2 $pid

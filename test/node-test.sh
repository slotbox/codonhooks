#!/bin/bash

set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

expect << EOF
  spawn $dir/fetch-repo-launcher.sh https://github.com/slotbox/nodejs-hello-world.git
  expect "Node.js app detected"
  expect "Fetching Node.js binaries"
  expect "Vendoring node into slug"
  expect "Installing dependencies with npm"
  expect "express"
  expect "Discovering process types"
  expect "Procfile declares types -> web"
  expect "Default process types for Node.js"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

cd /tmp/checkout
cat >> .env << EOF
PATH=bin:$PATH
PORT=9999
EOF

# Start foreman outside expect because difficulty successfully 
# sending SIGINT to clsoe down all child processes
foreman start &
pid=$!
sleep 5

expect << EOF
  spawn curl localhost:9999
  expect "Hello World :)"
EOF

# Kill foreman and all child processes
kill -2 $pid




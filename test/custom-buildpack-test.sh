#!/bin/bash

set -e

custom_buildpack_example="/tmp/checkout"

rm -fr $custom_buildpack_example
mkdir -p $custom_buildpack_example

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export BUILDPACK_URL=https://github.com/ryandotsmith/null-buildpack.git
expect << EOF
  spawn $dir/fetch-repo-launcher.sh https://github.com/slotbox/null-hello-world.git
  expect "Fetching custom buildpack"
  expect "Null app detected"
  expect "Nothing to do"
  expect "Procfile declares types -> program"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

cd /tmp/checkout
cat >> .env << EOF
PATH=bin:$PATH
EOF

expect << EOF
  spawn sudo foreman start
  expect "hello world"
  expect eof
EOF

rm -fr /tmp/buildpacks/buildpacks/custom

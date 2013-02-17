#!/bin/bash

set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -fr "/tmp/cache"
rm -rf /tmp/checkout
mkdir -p /tmp/checkout
cd /tmp/checkout
git init

export GIT_WORK_TREE=
export dyno_web_url="test.mymachine.me"
export slug_id=1234

BUILDPACKS_DIR="/tmp/buildpacks"
if [ ! -d "$BUILDPACKS_DIR/buildpacks" ]; then
  mkdir -p $BUILDPACKS_DIR
  curl -o "$BUILDPACKS_DIR/buildpacks.tgz" https://buildkits.herokuapp.com/buildkit/default.tgz
  tar xvzf "$BUILDPACKS_DIR/buildpacks.tgz" -C "$BUILDPACKS_DIR"
fi

$dir/../fetch-repo $1


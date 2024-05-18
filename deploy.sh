#!/bin/bash
set -euxo pipefail

hugo --environment production --cleanDestinationDir --minify --panicOnWarning
rsync -rvzhpg --delete --chmod=755 --chown=:http public/ javelin:/volume1/web/matt/blog
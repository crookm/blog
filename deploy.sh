#!/bin/bash
set -euxo pipefail

hugo --environment production --cleanDestinationDir --minify --panicOnWarning
rsync -rvz --delete public/ javelin:/volume1/web/matt/blog
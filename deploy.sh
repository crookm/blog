#!/bin/bash
set -euxo pipefail xtrace

hugo --gc --environment production --cleanDestinationDir --minify --panicOnWarning

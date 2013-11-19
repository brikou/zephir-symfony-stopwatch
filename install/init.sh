#!/usr/bin/env bash

set -e

apt-get update

# ==============================================================================
# init
# ------------------------------------------------------------------------------

apt-get install --quiet --yes python-software-properties
add-apt-repository ppa:ondrej/php5-oldstable
apt-get update

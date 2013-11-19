#!/usr/bin/env bash

set -e

if [ `which composer.phar` ]; then
    exit
fi

# ==============================================================================
# composer
# ------------------------------------------------------------------------------

apt-get install --quiet --yes curl php5-cli
cd /usr/local/bin/
curl --silent https://getcomposer.org/installer | php

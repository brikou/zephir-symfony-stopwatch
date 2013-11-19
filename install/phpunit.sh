#!/usr/bin/env bash

set -e

if [ `which phpunit` ]; then
    exit
fi

# ==============================================================================
# phpunit
# ------------------------------------------------------------------------------

apt-get install --quiet --yes php-pear
pear config-set auto_discover 1
pear install pear.phpunit.de/PHPUnit

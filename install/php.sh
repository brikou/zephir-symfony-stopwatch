#!/usr/bin/env bash

set -e

if [ `which php` ]; then
    exit
fi

# ==============================================================================
# php
# ------------------------------------------------------------------------------

apt-get install --quiet --yes patch php5

cd /usr/share/php5/
cp php.ini-development /etc/php5/apache2/php.ini
cp php.ini-development /etc/php5/cli/php.ini
diff -u php.ini-production{,.cli} | patch /etc/php5/cli/php.ini

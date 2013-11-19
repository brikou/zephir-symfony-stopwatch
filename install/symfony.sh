#!/usr/bin/env bash

set -e

if [ -d /vagrant/symfony/ext/ ]; then
    exit
fi

# ==============================================================================
# symfony
# ------------------------------------------------------------------------------

export ZEPHIRDIR=/usr/local/src/zephir/

cd /vagrant/symfony/
zephir init

cd /vagrant/
make compile
echo "extension=/usr/lib/php5/20100525/symfony.so" > /etc/php5/mods-available/symfony.ini
php5enmod symfony

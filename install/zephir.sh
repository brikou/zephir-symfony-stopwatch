#!/usr/bin/env bash

set -e

if [ `which zephir` ]; then
    exit
fi

# ==============================================================================
# json-c
# ------------------------------------------------------------------------------

apt-get install --quiet --yes git

cd /usr/local/src/
git clone https://github.com/json-c/json-c
cd json-c/
git checkout 06450206c4f3de4af8d81bb6d93e9db1d5fedec1

apt-get install --quiet --yes autoconf libtool make

sh autogen.sh
./configure
make
make install

# ==============================================================================
# zephir
# ------------------------------------------------------------------------------

cd /usr/local/src/
git clone https://github.com/phalcon/zephir
cd zephir/
git checkout 92d7d757c390411f1c4e01ff7d59361367d41065

cat << 'EOF' | patch --ignore-whitespace --strip 0
--- /usr/local/src/zephir/Library/Expression/PropertyAccess.php
+++ /usr/local/src/zephir/Library/Expression/PropertyAccess.php
@@ -144,10 +144,6 @@
                 */
                if ($classDefinition == $currentClassDefinition) {
                    if ($propertyDefinition->isPrivate()) {
-                       $declarationDefinition = $propertyDefinition->getDeclarationClass();
-                       if ($declarationDefinition != $currentClassDefinition) {
-                           throw new CompilerException("Attempt to access private property '" . $property . "' outside of its declared class context: '" . $declarationDefinition->getCompleteName() . "'", $expression);
-                       }
                    }
                } else {
                    if ($propertyDefinition->isProtected()) {
EOF

apt-get install --quiet --yes re2c

./install
ln -s /usr/local/src/zephir/bin/zephir /usr/local/bin/
echo "ZEPHIRDIR=/usr/local/src/zephir/" >> /etc/environment

# ==============================================================================
# phpize
# ------------------------------------------------------------------------------

apt-get install --quiet --yes libpcre3-dev php5-dev

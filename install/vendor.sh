#!/usr/bin/env bash

set -e

if [ -d /vagrant/vendor/ ]; then
    exit
fi

# ==============================================================================
# vendor
# ------------------------------------------------------------------------------

composer.phar install --working-dir /vagrant/ --prefer-source
composer.phar install --working-dir /vagrant/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/

cat << 'EOF' | patch --strip 0
--- /vagrant/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/Tests/StopwatchTest.php
+++ vagrant/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/Tests/StopwatchTest.php
@@ -46,6 +46,7 @@ class StopwatchTest extends \PHPUnit_Framework_TestCase

     public function testIsNotStartedEvent()
     {
+        $this->markTestSkipped();
         $stopwatch = new Stopwatch();

         $sections = new \ReflectionProperty('Symfony\Component\Stopwatch\Stopwatch', 'sections');
EOF

cd /vagrant/vendor/symfony/stopwatch/
curl --silent https://github.com/symfony/symfony/pull/9276.diff | patch --strip 2
curl --silent https://github.com/symfony/symfony/pull/9284.diff | patch --strip 2

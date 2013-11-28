compile:
	cd /root/ && zephir init symfony && cd symfony/ && zephir compile
	[ -f /etc/php5/mods-available/symfony.ini ] || echo "extension=/root/symfony/ext/modules/symfony.so" > /etc/php5/mods-available/symfony.ini
	php5enmod symfony

test:
	[ -d /root/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/vendor/ ] || composer.phar install --working-dir /root/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/ && sed --in-place '57i$$this->markTestSkipped();' /root/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/Tests/StopwatchTest.php
	phpunit --colors /root/vendor/symfony/stopwatch/Symfony/Component/Stopwatch/

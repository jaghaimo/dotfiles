#!/bin/bash
which composer || sudo apt install composer
composer global require hirak/prestissimo
composer global require friendsofphp/php-cs-fixer
composer global require vimeo/psalm

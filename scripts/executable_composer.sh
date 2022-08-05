#!/bin/bash
wget https://getcomposer.org/download/2.2.10/composer.phar
chmod +x composer.phar
(which composer && rm composer.phar) || sudo mv composer.phar /usr/local/bin/composer

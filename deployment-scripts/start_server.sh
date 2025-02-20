#!/bin/bash -ex
cd /var/www/html
npx serve -s /var/www/html -l 3000 > /dev/null 2>&1 &
